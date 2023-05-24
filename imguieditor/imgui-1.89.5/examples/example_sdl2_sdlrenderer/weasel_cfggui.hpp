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
        ImGuiIO& imguiio = ImGui::GetIO();
        (void)imguiio;
        imguiio.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard | ImGuiConfigFlags_NavEnableGamepad;
        imguiio.Fonts->AddFontDefault();
        imguiio.Fonts->AddFontFromFileTTF("c:\\Windows\\Fonts\\simhei.ttf", 12.0f, NULL, imguiio.Fonts->GetGlyphRangesChineseSimplifiedCommon());
        ImGui::StyleColorsClassic();

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
