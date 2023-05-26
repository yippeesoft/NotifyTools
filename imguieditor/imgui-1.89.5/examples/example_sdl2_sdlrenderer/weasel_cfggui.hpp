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
        ImGui::SeparatorText("选词栏反向");
        static int e = 1;
        if (ImGui::RadioButton("横向显示", &e, 0))
        {
            Log::d("RadioButton clk");
        };
        ImGui::SameLine();
        ImGui::RadioButton("竖向显示", &e, 1);
        ImGui::SeparatorText("候选词个数");
        static int f = 1;
        ImGui::SliderInt("个", &f, 1, 9);
        ImGui::SeparatorText("模糊音设置");

        //https://github.com/xiaolai/rime-settings
        //  # 【朙月拼音】模糊音定製模板
        //#佛振配製 : -)
        std::string chks[] = {
            "zh, ch, sh => z, c, s",
            "z, c, s => zh, ch, sh",
            "n => l",
            "l => n",
            "r => l"
            "l => r",
            "ren => yin, reng => ying",
            "r => y",
            "hu => fu"
            "hong => feng",

            "hui => fei, hun => fen",
            "hua => fa, ...",
            "fu => hu",
            "feng => hong",
            "fei => hui, fen => hun"
            "fa => hua, ...",

            "meng = mong, ...",
            "en => eng, in => ing",
            "eng => en, ing => in"
            "iong => un",
            "iong => un",
        };
        int size = _countof(chks);
        bool* bchks = new bool[size];
        //for (string& str : chks)
        for (int i = 0; i < size; ++i)
        {
            bchks[i] = false;
            ImGui::Checkbox(chks[i].data(), &bchks[i]);
        }

        ImGui::SeparatorText("设置");
        if (ImGui::Button("保存"))
        {
            Log::d("Button sav clk");
        }
        ImGui::SameLine();
        if (ImGui::Button("退出"))
        {
            Log::d("Button ext clk");
            std::exit(1);
        }

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
        // 避免 unused 变量的警告
        imguiio.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard; // Enable Keyboard Controls
        //io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;      // Enable Gamepad Controls
        //imguiio.ConfigFlags |= ImGuiConfigFlags_DockingEnable;   // !!! 启用 docking 功能的支持
        //imguiio.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable; // !!! 启用 viewport 功能的支持
        //io.ConfigViewportsNoAutoMerge = true;
        //io.ConfigViewportsNoTaskBarIcon = true;

        //imguiio.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard | ImGuiConfigFlags_NavEnableGamepad;
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
