[27/405] Building CXX object 3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml.dir\ggml-backend-dl.cpp.obj
[28/405] Building CXX object 3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml.dir\ggml-backend-reg.cpp.obj
FAILED: [code=1] 3rdparty/llama.cpp/ggml/src/CMakeFiles/ggml.dir/ggml-backend-reg.cpp.obj 
ccache "C:\Program Files\LLVM\bin\clang-cl.exe"  /nologo -TP -DGGML_SCHED_MAX_COPIES=4 -DGGML_USE_CPU -D_CRT_SECURE_NO_WARNINGS -D_XOPEN_SOURCE=600 -ID:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\ggml\src\..\include -w /MD /O2 /Ob2 /DNDEBUG -std:c++17 /utf-8 /bigobj /wd4005 /wd4244 /wd4267 /wd4305 /wd4566 /wd4996 /wd4702 -clang:-MD -clang:-MT3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml.dir\ggml-backend-reg.cpp.obj -clang:-MF3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml.dir\ggml-backend-reg.cpp.obj.d /Fo3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml.dir\ggml-backend-reg.cpp.obj /Fd3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml.dir\ggml.pdb -c -- D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\ggml\src\ggml-backend-reg.cpp
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\ggml\src\ggml-backend-reg.cpp(92,5): error: cannot use 'try' with exceptions disabled
   92 |     try {
      |     ^
1 error generated.
[29/405] Building CXX object 3rdparty\llama.cpp\src\CMakeFiles\llama.dir\llama.cpp.obj
FAILED: [code=1] 3rdparty/llama.cpp/src/CMakeFiles/llama.dir/llama.cpp.obj 
ccache "C:\Program Files\LLVM\bin\clang-cl.exe"  /nologo -TP -DGGML_USE_CPU -D_CRT_SECURE_NO_WARNINGS -ID:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\. -ID:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\..\..\..\include -ID:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\..\include -ID:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\ggml\src\..\include -w /MD /O2 /Ob2 /DNDEBUG -std:c++17 /utf-8 /bigobj -clang:-MD -clang:-MT3rdparty\llama.cpp\src\CMakeFiles\llama.dir\llama.cpp.obj -clang:-MF3rdparty\llama.cpp\src\CMakeFiles\llama.dir\llama.cpp.obj.d /Fo3rdparty\llama.cpp\src\CMakeFiles\llama.dir\llama.cpp.obj /Fd3rdparty\llama.cpp\src\CMakeFiles\llama.dir\llama.pdb -c -- D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp
In file included from D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp:9:
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama-model-loader.h(42,17): error: cannot use 'throw' with exceptions disabled
   42 |                 throw std::runtime_error(format("tensor '%s' not found in the model", ggml_get_name(tensor)));
      |                 ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama-model-loader.h(47,17): error: cannot use 'throw' with exceptions disabled
   47 |                 throw std::runtime_error(format("tensor '%s' data is not within the file bounds, model is corrupted or incomplete", ggml_get_name(tensor)));
      |                 ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp(311,13): error: cannot use 'throw' with exceptions disabled
  311 |             throw std::runtime_error("error loading model hyperparameters: " + std::string(e.what()));
      |             ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp(308,9): error: cannot use 'try' with exceptions disabled
  308 |         try {
      |         ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp(314,13): error: cannot use 'throw' with exceptions disabled
  314 |             throw std::runtime_error("CLIP cannot be used as main model, use it with --mmproj instead");
      |             ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp(319,13): error: cannot use 'throw' with exceptions disabled
  319 |             throw std::runtime_error("error loading model vocabulary: " + std::string(e.what()));
      |             ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp(316,9): error: cannot use 'try' with exceptions disabled
  316 |         try {
      |         ^
D:\a\ms-bitnet\ms-bitnet\upstream-bitnet\3rdparty\llama.cpp\src\llama.cpp(281,5): error: cannot use 'try' with exceptions disabled
  281 |     try {
      |     ^
8 errors generated.
[30/405] Building CXX object 3rdparty\llama.cpp\tools\ui\CMakeFiles\llama-ui-embed.dir\embed.cpp.obj
[31/405] Building CXX object 3rdparty\llama.cpp\ggml\src\CMakeFiles\ggml-cpu.dir\ggml-cpu\ops.cpp.obj
ninja: build stopped: subcommand failed.
Error: Process completed with exit code 1.