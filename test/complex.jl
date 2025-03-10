using Test
using Reactant

@testset "conj" begin
    @testset "$(typeof(x))" for x in (1.0, 1.0 + 2.0im)
        x_concrete = Reactant.to_rarray(x)
        @test only(@jit(conj(x_concrete))) == conj(x)
    end

    @testset "$(typeof(x))" for x in (
        fill(1.0 + 2.0im),
        fill(1.0),
        [1.0 + 2.0im; 3.0 + 4.0im],
        [1.0; 3.0],
        [1.0 + 2.0im 3.0 + 4.0im],
        [1.0 2.0],
        [1.0+2.0im 3.0+4.0im; 5.0+6.0im 7.0+8.0im],
        [1.0 3.0; 5.0 7.0],
    )
        x_concrete = Reactant.to_rarray(x)
        @test @jit(conj(x_concrete)) == conj(x)
    end
end

@testset "conj!" begin
    @testset "$(typeof(x))" for x in (
        fill(1.0 + 2.0im),
        fill(1.0),
        [1.0 + 2.0im; 3.0 + 4.0im],
        [1.0; 3.0],
        [1.0 + 2.0im 3.0 + 4.0im],
        [1.0 2.0],
        [1.0+2.0im 3.0+4.0im; 5.0+6.0im 7.0+8.0im],
        [1.0 3.0; 5.0 7.0],
    )
        x_concrete = Reactant.to_rarray(x)
        @test @jit(conj!(x_concrete)) == conj(x)
        @test x_concrete == conj(x)
    end
end

@testset "real" begin
    @testset "$(typeof(x))" for x in (1.0, 1.0 + 2.0im)
        x_concrete = Reactant.to_rarray(x)
        @test only(@jit(real(x_concrete))) == real(x)
    end

    @testset "$(typeof(x))" for x in (
        fill(1.0 + 2.0im),
        fill(1.0),
        [1.0 + 2.0im; 3.0 + 4.0im],
        [1.0; 3.0],
        [1.0 + 2.0im 3.0 + 4.0im],
        [1.0 2.0],
        [1.0+2.0im 3.0+4.0im; 5.0+6.0im 7.0+8.0im],
        [1.0 3.0; 5.0 7.0],
    )
        x_concrete = Reactant.to_rarray(x)
        @test @jit(real(x_concrete)) == real(x)
    end
end

@testset "imag" begin
    @testset "$(typeof(x))" for x in (1.0, 1.0 + 2.0im)
        x_concrete = Reactant.to_rarray(x)
        @test only(@jit(imag(x_concrete))) == imag(x)
    end

    @testset "$(typeof(x))" for x in (
        fill(1.0 + 2.0im),
        fill(1.0),
        [1.0 + 2.0im; 3.0 + 4.0im],
        [1.0; 3.0],
        [1.0 + 2.0im 3.0 + 4.0im],
        [1.0 2.0],
        [1.0+2.0im 3.0+4.0im; 5.0+6.0im 7.0+8.0im],
        [1.0 3.0; 5.0 7.0],
    )
        x_concrete = Reactant.to_rarray(x)
        @test @jit(imag(x_concrete)) == imag(x)
    end
end

@testset "abs: $T" for T in (Float32, ComplexF32)
    x = randn(T, 10)
    x_concrete = Reactant.to_rarray(x)
    @test @jit(abs.(x_concrete)) ≈ abs.(x)
end

@testset "promote_to Complex" begin
    x = 1.0 + 2.0im
    y = ConcreteRNumber(x)

    f = Reactant.compile((y,)) do z
        z + Reactant.TracedUtils.promote_to(Reactant.TracedRNumber{ComplexF64}, 1.0 - 3.0im)
    end

    @test isapprox(f(y), 2.0 - 1.0im)
end

@testset "complex reduction" begin
    x = randn(ComplexF32, 10, 10)
    x_ra = Reactant.to_rarray(x)
    @test @jit(sum(abs2, x_ra)) ≈ sum(abs2, x)
end
