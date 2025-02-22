abstract type AbstractDevice end

function Base.show(io::IO, ::MIME"text/plain", device::D) where {D<:AbstractDevice}
    print(io, "$(parentmodule(D)).Device($(device.device), \"$(string(device))\")")
    return nothing
end

function device end
function get_local_device_id end
function device_kind end
function default_memory end
function memories end

"""
    device_ordinal(device::Device)
    device_ordinal(client::XLA.AbstractClient, local_device_id::Int)

Given the device or local device id, return the corresponding global device ordinal in the client.
"""
function device_ordinal end

function device_ordinal(client::AbstractClient, local_device_id::Integer)
    return device_ordinal(get_addressable_device(client, local_device_id))
end

function Base.string(device::AbstractDevice)
    client = XLA.client(device)
    pname = XLA.platform_name(client)
    return "$(uppercase(pname)):$(device_ordinal(device)) $(device_kind(device))"
end
