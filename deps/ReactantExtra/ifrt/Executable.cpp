#include "src/type_conversion.hpp"
#include "src/error_handling.hpp"
#include "xla/python/ifrt/executable.h"

using namespace xla::ifrt;
using namespace reactant;

extern "C" const char* ifrt_executable_name(Executable* executable)
{
    return convert(Type<const char*>(), executable->name());
}

extern "C" const char* ifrt_executable_fingerprint(Executable* executable)
{
    auto result = MyValueOrThrow(executable->Fingerprint());
    if (!result.has_value())
        return "";
    return convert(Type<const char*>(), result.value());
}

extern "C" const char* ifrt_executable_serialize(Executable* executable)
{
    return convert(Type<const char*>(), MyValueOrThrow(executable->Serialize()));
}

extern "C" int ifrt_executable_num_devices(Executable* executable)
{
    return executable->num_devices();
}

extern "C" int64_t ifrt_executable_size(Executable* executable)
{
    return executable->SizeOfGeneratedCodeInBytes();
}

// TODO xla::Executable::GetCompiledMemoryStats

// extern "C" std::tuple<size_t, OpSharding*> ifrt_executable_parameter_shardings(Executable* executable)
// {
//     auto shardings = executable->GetParameterShardings();
//     if (!shardings.has_value())
//         return std::make_tuple(0, nullptr);
//     return std::make_tuple(shardings.value().size(), shardings.value().data());
// }

// extern "C" std::tuple<size_t, OpSharding*> ifrt_executable_output_shardings(Executable* executable)
// {
//     auto shardings = executable->GetOutputShardings();
//     if (!shardings.has_value())
//         return std::make_tuple(0, nullptr);
//     return std::make_tuple(shardings.value().size(), shardings.value().data());
// }

// TODO fix type conversion
// extern "C" span<xla::PjRtLayout*> ifrt_executable_parameter_layouts(Executable* executable)
// {
//     auto layouts = MyValueOrThrow(executable->GetParameterLayouts());
//     return convert(Type<span<xla::PjRtLayout*>>(), layouts);
// }

// TODO fix type conversion
// extern "C" span<xla::PjRtLayout*> ifrt_executable_output_layouts(Executable* executable)
// {
//     auto layouts = MyValueOrThrow(executable->GetOutputLayouts());
//     return convert(Type<span<xla::PjRtLayout*>>(), layouts);
// }

// TODO fix type conversion
// extern "C" span<xla::HloModule*> ifrt_executable_hlo_modules(Executable* executable)
// {
//     auto modules = MyValueOrThrow(executable->GetHloModules());
//     return convert(Type<span<xla::HloModule*>>(), modules);
// }

// TODO xla::Executable::GetCostAnalysis
