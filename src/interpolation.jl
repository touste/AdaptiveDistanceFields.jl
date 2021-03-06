@generated function evaluate(itp::AbstractInterpolation, point::SVector{N}) where N
    Expr(:call, :itp, [:(point[$i]) for i in 1:N]...)
end

function evaluate(itp::AbstractInterpolation, point::AbstractArray)
    itp(point...)
end

function evaluate(cell::Cell{D}, point::AbstractArray) where {D <: AbstractInterpolation}
    leaf = findleaf(cell, point)
    evaluate(leaf.data, leaf.boundary, point)
end

function evaluate(interp::AbstractInterpolation, boundary::HyperRectangle, point::AbstractArray)
    coords = (point - boundary.origin) ./ boundary.widths .+ 1
    evaluate(interp, coords)
end





@generated function fieldgradient(itp::AbstractInterpolation, point::SVector{N}) where N
    Expr(:call, :gradient, :itp, [:(point[$i]) for i in 1:N]...)
end

function fieldgradient(cell::Cell{D}, point::AbstractArray) where {D <: AbstractInterpolation}
    leaf = findleaf(cell, point)
    fieldgradient(leaf.data, leaf.boundary, point)
end

function fieldgradient(interp::AbstractInterpolation, boundary::HyperRectangle, point::AbstractArray)
    coords = (point - boundary.origin) ./ boundary.widths .+ 1
    fieldgradient(interp, coords) ./ boundary.widths
end

function fieldgradient(itp::AbstractInterpolation, point::AbstractArray)
    gradient(itp, point...)
end





@generated function fieldhessian(itp::AbstractInterpolation, point::SVector{N}) where N
    Expr(:call, :hessian, :itp, [:(point[$i]) for i in 1:N]...)
end

function fieldhessian(cell::Cell{D}, point::AbstractArray) where {D <: AbstractInterpolation}
    leaf = findleaf(cell, point)
    fieldhessian(leaf.data, leaf.boundary, point)
end

function fieldhessian(interp::AbstractInterpolation, boundary::HyperRectangle, point::AbstractArray)
    coords = (point - boundary.origin) ./ boundary.widths .+ 1
    fieldhessian(interp, coords) ./ (boundary.widths*boundary.widths')
end

function fieldhessian(itp::AbstractInterpolation, point::AbstractArray)
    hessian(itp, point...)
end
