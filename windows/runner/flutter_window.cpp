#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>
#include <shlobj.h>

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  
  // Custom Method Channel for Native Actions
  flutter::MethodChannel<> channel(
      flutter_controller_->engine()->messenger(), "com.example.duplicateFileFinder/native",
      &flutter::StandardMethodCodec::GetInstance());

  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        if (call.method_name() == "moveToTrash") {
            const auto* arguments = std::get_if<std::string>(call.arguments());
            if (!arguments) {
                result->Error("INVALID_ARGUMENT", "Argument must be a string path");
                return;
            }
            std::string path = *arguments;

            // Convert UTF-8 path to Wide String
            int count = MultiByteToWideChar(CP_UTF8, 0, path.c_str(), path.length(), NULL, 0);
            if (count == 0) {
                 result->Error("TRASH_ERROR", "Failed to convert path to wide string");
                 return;
            }
            std::wstring wpath(count, 0);
            MultiByteToWideChar(CP_UTF8, 0, path.c_str(), path.length(), &wpath[0], count);
            wpath.append(1, L'\0'); // Double null termination

            SHFILEOPSTRUCTW fileOp = {0};
            fileOp.wFunc = FO_DELETE;
            fileOp.pFrom = wpath.c_str();
            fileOp.fFlags = FOF_ALLOWUNDO | FOF_NOCONFIRMATION | FOF_SILENT;

            int ret = SHFileOperationW(&fileOp);
            if (ret == 0) {
                if (fileOp.fAnyOperationsAborted) {
                    result->Success(false);
                } else {
                    result->Success(true);
                }
            } else {
                result->Error("TRASH_ERROR", "Failed to move file to trash", std::to_string(ret));
            }
        } else if (call.method_name() == "revealInFinder") {
            const auto* arguments = std::get_if<std::string>(call.arguments());
            if (!arguments) {
                result->Error("INVALID_ARGUMENT", "Argument must be a string path");
                return;
            }
            std::string path = *arguments;

            int count = MultiByteToWideChar(CP_UTF8, 0, path.c_str(), path.length(), NULL, 0);
            if (count == 0) {
                 result->Error("REVEAL_ERROR", "Failed to convert path to wide string");
                 return;
            }
            std::wstring wpath(count, 0);
            MultiByteToWideChar(CP_UTF8, 0, path.c_str(), path.length(), &wpath[0], count);

            std::wstring params = L"/select,\"";
            params += wpath;
            params += L"\"";

            HINSTANCE hInst = ShellExecuteW(NULL, L"open", L"explorer.exe", params.c_str(), NULL, SW_SHOWDEFAULT);
            if ((intptr_t)hInst > 32) {
                result->Success(true);
            } else {
                result->Error("REVEAL_ERROR", "Failed to reveal file in explorer", std::to_string((intptr_t)hInst));
            }
        } else {
            result->NotImplemented();
        }
      });

  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}