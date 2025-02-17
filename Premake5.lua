------------------------------------------------------------------------------

local ProjectRelativeFinalDataRoot = "$(ProjectDir)../../../../toolchain/FuetEngine"
local ProjectRelativeSDKSRoot = "$(ProjectDir)../../../SDKS"
local ProjectRelativeFuetEngineRoot = "$(ProjectDir)../../FuetEngine"
local SDKSRoot = "$(FuetEngineProjectsDev)/shared/src/sdks"
local FuetEngineRoot = "$(FuetEngineProjectsDev)/shared/src/FuetEngineFramework/FuetEngine"

scriptRoot = os.getcwd()	
frameworkRoot = scriptRoot .. "/../FuetEngine"
------------------------------------------------------------------------------
workspace "freealut"
    configurations { "Debug", "Release" }
    platforms { "Win32", "x64" }	
    location "build" -- Where generated files (like Visual Studio solutions) will be stored

	filter {"platforms:Win32"}
	architecture "x86"
	filter {"platforms:x64"}
	architecture "x86_64"
	filter {}

project "alut"
    kind "StaticLib" -- Change to "SharedLib" for a shared library
    language "C++"
    cppdialect "C++17"
    targetdir "$(ProjectDir)/../lib/%{cfg.platform}/%{cfg.buildcfg}" -- Output directory for binaries
    objdir "$(ProjectDir)obj/%{cfg.platform}/%{cfg.buildcfg}" -- Output directory for intermediate files
	characterset("ASCII")
	sourceDir = "$(ProjectDir)../src"
	buildoutputs { "alut" }

	-- Specify the root directory of the library
    local sourceRoot = os.getcwd() .. "/src"

    -- Recursively include all .cpp and .h files from the sourceRoot directory
    files {
        sourceRoot .. "/**.c",
        sourceRoot .. "/**.h"
    }

	-- specific defines for this project
	defines {
		"HAVE_CONFIG_H=1",
		"ALUT_BUILD_STATIC",
	}
	
	filter { "system:windows" }
		defines { 
			"WIN32",
			"_MBCS",	
			"_WINDOWS",
		}
	filter {} -- Reset filter

    -- Add include directories (sourceRoot is included by default)
    includedirs {
		"$(ProjectDir)../src/..",
		"$(ProjectDir)../include",	
		SDKSRoot .. "/externals/OpenAL_1.1_SDK/include/AL",
    }

    -- Configuration-specific settings
    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations

	filter {} -- Clear filter for general settings

