#include "src/type_conversion.hpp"
#include "src/error_handling.hpp"
#include "xla/python/pjrt_ifrt/pjrt_executable.h"

using namespace xla::ifrt;
using namespace reactant;

// TODO is there any problem with ownership by using `std::shared_ptr` here?
extern "C" Executable* ifrt_pjrt_executable_ctor(xla::PjRtExecutable* c_pjrt_executable, XlaCompileOptions* c_compile_options) {
    auto pjrt_executable = std::shared_ptr<xla::PjRtExecutable>(c_pjrt_executable);
    auto compile_options = std::make_unique<XlaCompileOptions>(*c_compile_options);
    return MyValueOrThrow(PjRtExecutable::Create(pjrt_executable, std::move(compile_options))).release();
}

extern "C" void ifrt_pjrt_executable_free(PjRtExecutable* executable) { delete executable; }

extern "C" xla::PjRtExecutable* ifrt_pjrt_executable_pjrt_executable(PjRtExecutable* executable)
{
    return executable->pjrt_executable();
}
