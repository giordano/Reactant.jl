using Boltz, Lux, Random, LuxCUDA
using Reactant
using BenchmarkTools

dev = gpu_device()

model = Vision.ViT(:tiny);
ps, st = Lux.setup(Random.default_rng(), model);

ps_gpu, st_gpu = ps, st |> dev;

x = rand(Float32, 256, 256, 3, 16);

x_ra = Reactant.to_rarray(x);
ps_ra = Reactant.to_rarray(ps);
st_ra = Reactant.to_rarray(st);

apply_compiled = @compile Lux.apply(model, x_ra, ps_ra, st_ra);

lux_timing = @benchmark begin
    Lux.apply($model, $x, $ps, $st)
    CUDA.synchronize()
end

reactant_timing = @benchmark begin
    res = $apply_compiled($model, $x_ra, $ps_ra, $st_ra)
    Reactant.synchronize(res)
end
