#ifndef __SYS_WEASEL_GUI_
#define __SYS_WEASEL_GUI_

#include <SDL2/SDL.h>
#include "weasel_cfg.hpp"
namespace fs = std::filesystem;

using namespace std;

namespace weasel_cfg {

class CfgGui
{
public:
    static std::string w2s(const std::string& str)
    {
        int nwLen = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, NULL, 0);
        wchar_t* pwBuf = new wchar_t[nwLen + 1];
        memset(pwBuf, 0, nwLen * 2 + 2);
        MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), pwBuf, nwLen);

        int nLen = WideCharToMultiByte(CP_ACP, 0, pwBuf, -1, NULL, NULL, NULL, NULL);
        char* pBuf = new char[nLen + 1];
        memset(pBuf, 0, nLen + 1);
        WideCharToMultiByte(CP_ACP, 0, pwBuf, nwLen, pBuf, nLen, NULL, NULL);

        std::string ret = pBuf;
        delete[] pBuf;
        delete[] pwBuf;

        return ret;
    }

    static std::string s2w(const std::string& str)
    {
        int nwLen = MultiByteToWideChar(CP_ACP, 0, str.c_str(), -1, NULL, 0);
        wchar_t* pwBuf = new wchar_t[nwLen + 1];
        memset(pwBuf, 0, nwLen * 2 + 2);
        MultiByteToWideChar(CP_ACP, 0, str.c_str(), str.length(), pwBuf, nwLen);

        int nLen = WideCharToMultiByte(CP_UTF8, 0, pwBuf, -1, NULL, NULL, NULL, NULL);
        char* pBuf = new char[nLen + 1];
        memset(pBuf, 0, nLen + 1);
        WideCharToMultiByte(CP_UTF8, 0, pwBuf, nwLen, pBuf, nLen, NULL, NULL);

        std::string ret = pBuf;
        delete[] pwBuf;
        delete[] pBuf;

        return ret;
    }

    static void createCfg()
    {
        ImGui::Begin("小狼毫选项");
        static int e = 0;
        ImGui::RadioButton("横向显示", &e, 0);
        ImGui::SameLine();
        ImGui::RadioButton("竖向显示", &e, 1);

        ImGui::End();
    }
    static int show()
    {
        if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER) != 0)
        {
            Log::d(" sdl init error");
            return -1;
        }

#ifdef SDL_HINT_IME_SHOW_UI
        SDL_SetHint(SDL_HINT_IME_SHOW_UI, "1");
#endif
        SDL_WindowFlags win_flags = (SDL_WindowFlags)(SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
        SDL_Window* win = SDL_CreateWindow("小狼毫配置", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 800, win_flags);
        SDL_Renderer* renderer = SDL_CreateRenderer(win, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);
        if (renderer == nullptr)
        {
            SDL_Log("err renderer");
            return -1;
        }
        SDL_RendererInfo rendererinfo;
        SDL_GetRendererInfo(renderer, &rendererinfo);
        SDL_Log("renderer info %s", rendererinfo.name);

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();

        ImGui::StyleColorsClassic();

        ImGuiIO& imguiio = ImGui::GetIO();
        (void)imguiio;
        imguiio.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard | ImGuiConfigFlags_NavEnableGamepad;
        //imguiio.Fonts->AddFontDefault();
        ImFont* font = imguiio.Fonts->AddFontFromFileTTF("c:/windows/fonts/msyh.ttc", 15.0f, NULL, imguiio.Fonts->GetGlyphRangesChineseFull());
        //imguiio.Fonts->Build();
        //ImGui::PushFont(font);

        ImGui_ImplSDL2_InitForSDLRenderer(win, renderer);
        ImGui_ImplSDLRenderer_Init(renderer);

        bool quitt = false;
        while (!quitt)
        {
            SDL_Event event;
            while (SDL_PollEvent(&event))
            {
                ImGui_ImplSDL2_ProcessEvent(&event);
                if (event.type == SDL_QUIT)
                    quitt = true;
                if (event.type == SDL_WINDOWEVENT && event.window.event == SDL_WINDOWEVENT_CLOSE && event.window.windowID == SDL_GetWindowID(win))
                    quitt = true;
            }

            ImGui_ImplSDLRenderer_NewFrame();
            ImGui_ImplSDL2_NewFrame();
            ImGui::NewFrame();

            createCfg();

            ImGui::Render();
            SDL_RenderSetScale(renderer, imguiio.DisplayFramebufferScale.x, imguiio.DisplayFramebufferScale.y);
            SDL_RenderClear(renderer);
            ImGui_ImplSDLRenderer_RenderDrawData(ImGui::GetDrawData());
            SDL_RenderPresent(renderer);
        }

        ImGui_ImplSDLRenderer_Shutdown();
        ImGui_ImplSDL2_Shutdown();
        ImGui::DestroyContext();

        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(win);
        SDL_Quit();

        return 0;
    }
};

} // namespace weasel_cfg

#endif
