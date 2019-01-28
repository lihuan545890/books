-- http://industriousone.com/scripting-reference

local action = _ACTION or ""
local OPENCV_PATH = "d:/opencv/build"
-- OPENCV_PATH = "d:/opencv4/build"

OPENCV_VER = 2410

solution "opencv-cookbook"
    location (action)
    configurations { "Debug", "Release" }
    platforms {"x64"}
    language "C++"

    os.mkdir("bin")
    targetdir ("bin")

    -- TODO: it's ugly but it works
    if os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world330.dll")) then
        OPENCV_VER = 330
    elseif os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world331.dll")) then
        OPENCV_VER = 331
    elseif os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world340.dll")) then
        OPENCV_VER = 340
    elseif os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world341.dll")) then
        OPENCV_VER = 341
    elseif os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world342.dll")) then
        OPENCV_VER = 342
    elseif os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world343.dll")) then
        OPENCV_VER = 343
    elseif os.isfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_world400.dll")) then
        OPENCV_VER = 400
    end

    filter "action:vs*"
        defines { "_CRT_SECURE_NO_WARNINGS" }
        if not os.isfile("bin/opencv_core" .. OPENCV_VER .. "d.dll") then
            os.copyfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_core" .. OPENCV_VER .. "d.dll"), "bin/opencv_core" .. OPENCV_VER .. "d.dll")
            os.copyfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_highgui" .. OPENCV_VER .. ".dll"), "bin/opencv_highgui" .. OPENCV_VER .. ".dll")
            os.copyfile(path.join(OPENCV_PATH, "x64/vc10/bin/opencv_ffmpeg"  .. OPENCV_VER .. "_64.dll"), "bin/opencv_ffmpeg"  .. OPENCV_VER .. "_64.dll")
        end

    filter "system:macosx"
        defines {
            "_MACOSX",
        }

    configuration "Debug"
        defines { "DEBUG" }
        symbols "On"
        targetsuffix "-d"

    configuration "Release"
        defines { "NDEBUG" }
        flags { "No64BitChecks" }
        editandcontinue "Off"
        optimize "Speed"
        optimize "On"
        editandcontinue "Off"

    function create_example_project( example )
        local proj = example[1]
        project (proj)
            kind "ConsoleApp"
            files {
                {table.unpack(example, 2, 8)}
            }

            includedirs { 
                path.join(OPENCV_PATH, "include")
            }

            libdirs {
                path.join(OPENCV_PATH, "x64/vc10/lib"),
            }

            configuration "Debug"
                links {
                    "opencv_core".. OPENCV_VER.."d",
                    "opencv_highgui".. OPENCV_VER.."d",								
                }
            
            configuration "Release"
                links {
                    "opencv_core".. OPENCV_VER,
                    "opencv_highgui".. OPENCV_VER,								
                }
    end

    local examples = {
        {"01-main1", "Chapter 01/main1.cpp"},
        {"01-main2", "Chapter 01/main2.cpp"},
        {"02-addImages", "Chapter 02/addImages.cpp"},
        {"02-colorReduce", "Chapter 02/colorReduce.cpp"},
        {"02-contrast", "Chapter 02/contrast.cpp"},
        {"02-saltImage", "Chapter 02/saltImage.cpp"},
        {"03-colorDetection", "Chapter 03/colorDetection.cpp", "Chapter 03/colordetector.cpp"},
        {"04-finder", "Chapter 04/finder.cpp"},
        {"04-histograms", "Chapter 04/histograms.cpp"},
        {"04-objectfinder", "Chapter 04/objectfinder.cpp"},
        {"04-retrieve", "Chapter 04/retrieve.cpp"},
        {"05-morpho2", "Chapter 05/morpho2.cpp"},
        {"05-morphology", "Chapter 05/morphology.cpp"},
        {"05-segment", "Chapter 05/segment.cpp"},
        {"06-derivatives", "Chapter 06/derivatives.cpp"},
        {"06-filters", "Chapter 06/filters.cpp"},
        {"07-blobs", "Chapter 07/blobs.cpp"},
        {"07-contours", "Chapter 07/contours.cpp"},
        {"08-interestPoints", "Chapter 08/interestPoints.cpp"},
        {"08-tracking", "Chapter 08/tracking.cpp"},
        {"09-calibrate", "Chapter 09/calibrate.cpp", "Chapter 09/CameraCalibrator.cpp"},
        {"09-estimateF", "Chapter 09/estimateF.cpp"},
        {"09-estimateH", "Chapter 09/estimateH.cpp"},
        {"09-robustmatching", "Chapter 09/robustmatching.cpp"},
        {"10-foreground", "Chapter 10/foreground.cpp"},
        {"10-tracking", "Chapter 10/tracking.cpp"},
        {"10-videoprocessing", "Chapter 10/videoprocessing.cpp"},
    }
    for _, example in ipairs(examples) do
        create_example_project(example)
    end

