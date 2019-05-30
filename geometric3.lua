require("context")

pi = cached(acos(constant(-1.0))/constant(2.0))

-- TRANSFORMATIONS
function translate_x(a)
    local msg="translate_x( a ) with a scalar variable or expression\n   translate along the X-axis with the given value\n\n"
    namedcheck({"first argument"},{a},{"expression_double|number"},msg)
    if extendedtype(a)=="number" then
        a = constant(a)
    end
    return frame(vector(a,constant(0),constant(0)))
end

function translate_y(a)
    local msg="translate_y( a ) with a scalar variable or expression\n   translate along the Y-axis with the given value\n\n"
    namedcheck({"first argument"},{a},{"expression_double|number"},msg)
    if extendedtype(a)=="number" then
        a = constant(a)
    end
    return frame(vector(constant(0),a,constant(0)))
end

function translate_z(a)
    local msg="translate_z( a ) with a scalar variable or expression\n   translate along the Z-axis with the given value\n\n"
    namedcheck({"first argument"},{a},{"expression_double|number"},msg)
    if extendedtype(a)=="number" then
        a = constant(a)
    end
    return frame(vector(constant(0),constant(0),a))
end

function rotate_x(a)
    local msg="rotate_x( a ) with a scalar variable or expression\n   rotates along the X-axis with the given value\n\n"
    namedcheck({"first argument"},{a},{"expression_double|number"},msg)
    if extendedtype(a)=="number" then
        a = constant(a)
    end
    return frame(rot_x(a))
end

function rotate_y(a)
    local msg="rotate_y( a ) with a scalar variable or expression\n   rotates along the Y-axis with the given value\n\n"
    namedcheck({"first argument"},{a},{"expression_double|number"},msg)
    if extendedtype(a)=="number" then
        a = constant(a)
    end
    return frame(rot_y(a))
end

function rotate_z(a)
    local msg="rotate_z( a ) with a scalar variable or expression\n   rotates along the Z-axis with the given value\n\n"
    namedcheck({"first argument"},{a},{"expression_double|number"},msg)
    if extendedtype(a)=="number" then
        a = constant(a)
    end
    return frame(rot_z(a))
end


-- ANGLES
function angle_line_line(w_a,w_b)
    local msg=[[ angle_line_line(w_a, w_b) 
                 INPUT: 
                    w_a : expression for the direction of the first line
                    w_b : expression for the direction of the second line
                 OUTPUT:
                    returns an expression for the angle between two lines
                    the returned value is in the interval [-pi .. pi] 

                 REMARK:
                    computed via atan2.
    ]]
    if w_a==nil and w_b==nil then
        print(msg)
        return
    end
    namedcheck({"w_a","w_b"},{w_a,w_b},{"expression_vector","expression_vector"}, msg)
    local ca = cached(w_a)
    local cb = cached(w_b)
    return cached(atan2( norm(cross(ca,cb)) , dot(ca,cb) ))
end

function angle_line_plane(w,n)
    local msg=[[ angle_line_plane(w,n) 
                 INPUT:  
                    w : expression for a the direction of the line
                    n : expression for the vector of the plane normal
                 OUTPUT:
                    returns an expression for the angle between a line and the plane
                    the returned value is in the interval [-pi/2 .. pi/2] 

                 REMARK:
                    computed via atan2.
    ]]
    if w==nil and n==nil then
        print(msg)
        return
    end
    namedcheck({"w","n"},{w,n},{"expression_vector","expression_vector"}, msg)
    local cw = cached(w)
    local cn = cached(n)
    return cached( abs(atan2( norm(cross(cP,a)) , dot(cP,a))) - pi/constant(2.0) )
end

function angle_plane_plane(n_a,n_b)
    local msg=[[ angle_plane_plane(n_a, n_b) 
                 INPUT: 
                    n_a : expression for a vector of the plane normal  
                    n_b : expression for a vector of the plane normal
                 OUTPUT:
                    returns an expression for the angle between the two planes
                    (i.e. between the normals of the planes )
                    the returned value is in the interval [-pi .. pi]

                 REMARK:
                    computed via atan2.
    ]]
    if n_a==nil and n_b==nil then
        print(msg)
        return
    end
    namedcheck({"n_a","n_b"},{n_a,n_b},{"expression_vector","expression_vector"}, msg)
    local ca = cached(n_a)
    local cb = cached(n_b)
    return cached(atan2( norm(cross(ca,cb)) , dot(ca,cb) ))
end

-- DISTANCE
function distance_point_point(p_a,p_b)
    local msg=[[ distance_point_point(p_a, p_b) 
                 INPUT: 
                    p_a : expression for a vector representing a point
                    p_b : expression for a vector representing a point
                 OUTPUT:
                    returns the distance between the two points.

    ]]
    if p_a==nil and p_b==nil then
        print(msg)
        return
    end
    namedcheck({"p_a","p_b"},{p_a,p_b},{"expression_vector","expression_vector"}, msg)
    return cached( norm(p_a-p_b) )
end

function distance_point_line(p, q, w)
    local msg=[[ distance_point_line(p, q, w) 
                 INPUT: 
                    p : expression for a vector representing a point
                    q : expression for a vector representing a point on the line
                    w : expression for the direction vector of the line
                 OUTPUT:
                    returns the distance between the line and the point

    ]]
    if p==nil and q==nil and w==nil then
        print(msg)
        return
    end
    namedcheck({"p","q","w"},{p,q,w},{"expression_vector","expression_vector","expression_vector"}, msg)
 
    local cp = cached(p)
    local cq = cached(q)
    local cw = cached(w)
    local d = cached( cp - cq  )
    return cached(norm( d - cw*dot(cw,d) ))
end

function distance_point_plane(p, q, n)
    local msg = [[ distance_point_plane(p, q, n) 
                INPUT: 
                    p : expression for a vector representing the point
                    q : expression for a vector representing a point on the plane
                    n : expression for a vector representing the normal of the plane
                OUTPUT:
                returns the distance between the point and the plane

    ]]
    if p==nil and q==nil and n==nil then
        print(msg)
        return
    end
    namedcheck({"p","q","n"},{p,q,n},{"expression_vector","expression_vector","expression_vector"}, msg)
    local cp = cached(p)
    local cq = cached(q)
    local cn = cached(n)
    return cached(abs(dot(cp - cq, cn)))
end

function distance_line_line(q_a, w_a, q_b ,w_b)
    local msg=[[ distance_line_line(q_a,w_a,q_b,w_b) 
                 INPUT: 
                 q_a : expression for a vector representing a point on the first line
                 w_a : expression for the direction vector of the first line
                 q_b : expression for a vector representing a point on the second line
                 w_b : expression for the direction vector of the second line
                 OUTPUT:
                    returns the distance between the two lines

    ]]
    if q_a==nil and w_a==nil and q_b==nil and w_b==nil then
        print(msg)
        return
    end
    namedcheck({"q_a","w_a","q_b","w_b"},{q_a,w_a,q_b,w_b},{"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)
 
    local cq_a = cached(q_a)
    local cw_a = cached(w_a)
    local cq_b = cached(q_b)
    local cw_b = cached(w_b)
    local n  = cached(cross(cw_a,cw_b))
    local nn = cached(norm(n))
    return cached(near_zero(nn,1E-8,
                distance_point_line(cq_a,cq_b,cw_b),
                abs(dot(cq_a - cq_b,n))/nn
           ))
end

function distance_line_plane(q_l, w, q_p, n)
    local msg=[[ distance_line_plane(q_l, w, q_p, n) 
                 INPUT: 
                    q_l : expression for a vector representing a point on the line
                    w : expression for the direction vector of the line
                    q_p : expression for a vector representing a point on the plane
                    n : expression for a vector representing the normal of the plane
                 OUTPUT:
                    returns the distance between the line and the plane (0 if they are not parallell)

    ]]
    if q_l==nil and w==nil and q_p==nil and n==nil then
        print(msg)
        return
    end
    namedcheck({"q_l","w","q_p","n"},{q_l,w,q_p,n},{"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)
 
    local cq_l = cached(q_l)
    local cw = cached(w)
    local cq_p = cached(q_p)
    local cn = cached(n)
    local cdot  = cached(dot(w,n))
    return cached(near_zero(cdot,1E-8,
                distance_point_plane(cq_l,cq_p,cn),
                constant(0.0)
           ))
end

function distance_plane_plane(q_a,n_a,q_b,n_b)
    local msg=[[ distance_plane_plane(q_a,n_a,q_b,n_b)
                 INPUT: 
                    q_a : expression for a vector representing a ponit on the first plane
                    n_a : expression for a vector representing the normal of the first plane
                    q_b : expression for a vector representing a ponit on the second plane
                    n_b : expression for a vector representing the normal of the second plane
                 OUTPUT:
                    returns the distance between the planes (0 if they are not parallell)

    ]]
    if q_a==nil and n_a==nil and q_b==nil and n_b==nil then
        print(msg)
        return
    end
    namedcheck({"q_a","n_a","q_b","n_b"},{q_a,n_a,q_b,n_b},{"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)
 
    local cq_a = cached(q_a)
    local cn_a = cached(n_a)
    local cq_b = cached(q_b)
    local cn_b = cached(n_b)
    local n  = cached(cross(cn_a,cn_b))
    local nn = cached(norm(n))
    return cached(near_zero(nn,1E-8,
                distance_point_plane(cq_a,cq_b,cn_b),
                constant(0.0)
           ))
end

-- COINCIDENT
function Coincident_point_point(arg)
    local msg="This function is called as follows:\n" ..
        "Coincident_point_point{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [Point a] (vector)\n" ..
        "   point_b     = ...   [Point b] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","point_b"},{arg.point_a,arg.point_b},{"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "coincident_point_point_" .. tostring(counter("coincident_point_point"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_point_point(arg.point_a,arg.point_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Coincident_line_point(arg)
    Coincident_point_line{}
end

function Coincident_point_line(arg)
    local msg="This function is called as follows:\n" ..
        "Coincident_point_line{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [Point a] (vector)\n" ..
        "   point_b     = ...   [A point on the line] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of the line] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","point_b","dir_b"},{arg.point_a,arg.point_b,arg.dir_b},
        {"expression_vector","expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "coincident_point_line_" .. tostring(counter("coincident_point_line"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_point_line(arg.point_a,arg.point_b,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Coincident_plane_point(arg)
    Coincident_point_plane{}
end

function Coincident_point_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Coincident_point_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [Point a] (vector)\n" ..
        "   point_b     = ...   [A point on the plane] (vector)\n" ..
        "   dir_b       = ...   [Normal vector of the plane] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","point_b","dir_b"},{arg.point_a,arg.point_b,arg.dir_b},
        {"expression_vector","expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "coincident_point_plane_" .. tostring(counter("coincident_point_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_point_plane(arg.point_a,arg.point_b,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Coincident_line_line(arg)
    local msg="This function is called as follows:\n" ..
        "Coincident_line_line{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on line a] (vector)\n" ..
        "   dir_a       = ...   [Direction vector of line a] (vector)\n" ..
        "   point_b     = ...   [A point on line b] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of line a] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","point_b","dir_b"},{arg.point_a,arg.dir_a,arg.point_b,arg.dir_b},
        {"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "coincident_line_line_" .. tostring(counter("coincident_line_line"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name .. "_angle_line_line",
        expr        = angle_line_line(arg.dir_a,arg.dir_b),
        K           = arg.K*1.5,
        weight      = arg.weight,
        priority    = arg.priority
    }
    Constraint{
        context     = arg.context,
        name        = arg.name .. "_distance_line_line",
        expr        = distance_line_line(arg.point_a, arg.dir_a, arg.point_b ,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Coincident_plane_line(arg)
    Coincident_line_plane{}
end

function Coincident_line_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Coincident_line_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on the line] (vector)\n" ..
        "   dir_a       = ...   [Direction vector of the line] (vector)\n" ..
        "   point_b     = ...   [A point on the plane] (vector)\n" ..
        "   dir_b       = ...   [Normal vector of the plane] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","point_b","dir_b"},{arg.point_a,arg.dir_a,arg.point_b,arg.dir_b},
        {"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "coincident_line_plane_" .. tostring(counter("coincident_line_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name .. "_angle_line_plane",
        expr        = angle_line_plane(arg.dir_a,arg.dir_b),
        K           = arg.K*1.5,
        weight      = arg.weight,
        priority    = arg.priority
    }
    Constraint{
        context     = arg.context,
        name        = arg.name .. "_distance_line_plane",
        expr        = distance_line_plane(arg.point_a, arg.dir_a, arg.point_b, arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Coincident_plane_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Coincident_plane_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on plane a] (vector)\n" ..
        "   dir_a       = ...   [Normal vector of plane a] (vector)\n" ..
        "   point_b     = ...   [A point on plane b] (vector)\n" ..
        "   dir_b       = ...   [Normal vector of plane b] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","point_b","dir_b"},{arg.point_a,arg.dir_a,arg.point_b,arg.dir_b},
        {"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "coincident_plane_plane_" .. tostring(counter("coincident_plane_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name .. "_angle_plane_plane",
        expr        = angle_plane_plane(arg.dir_a,arg.dir_b),
        K           = arg.K*1.5,
        weight      = arg.weight,
        priority    = arg.priority
    }
    Constraint{
        context     = arg.context,
        name        = arg.name .. "_distance_plane_plane",
        expr        = distance_plane_plane(arg.point_a,arg.dir_a,arg.point_b,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

-- CONCENTRIC
function Concentric(arg)
    local msg="This function is called as follows:\n" ..
        "Concentric{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on line a] (vector)\n" ..
        "   dir_a       = ...   [Direction vector of line a] (vector)\n" ..
        "   point_b     = ...   [A point on line b] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of line a] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","point_b","dir_b"},{arg.point_a,arg.dir_a,arg.point_b,arg.dir_b},
        {"expression_vector","expression_vector","expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "concentric_" .. tostring(counter("concentric"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Coincident_line_line{
        context     = arg.context,
        name        = arg.name,
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority,
        point_a     = arg.point_a,
        dir_a       = arg.dir_a,
        point_b     = arg.point_b,
        dir_b       = arg.dir_b
    }
end

-- PERPENDICULAR
function Perpendicular_line_line(arg)
    local msg="This function is called as follows:\n" ..
        "Perpendicular_line_line{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   dir_a       = ...   [Direction vector of line a] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of line a] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"dir_a","dir_b"},{arg.dir_a,arg.dir_b},
        {"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "perpendicular_line_line_" .. tostring(counter("perpendicular_line_line"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = abs(angle_line_line(arg.dir_a,arg.dir_b)),
        target      = pi/constant(2.0),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Perpendicular_plane_line(arg)
    Perpendicular_line_plane{}
end

function Perpendicular_line_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Perpendicular_line_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   dir_a       = ...   [Direction vector of the line] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of the plane] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"dir_a","dir_b"},{arg.dir_a,arg.dir_b},
        {"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "perpendicular_line_plane_" .. tostring(counter("perpendicular_line_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = abs(angle_line_plane(arg.dir_a,arg.dir_b)),
        target      = pi/constant(2.0),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Perpendicular_plane_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Perpendicular_plane_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   dir_a       = ...   [Direction vector of plane a] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of plane b] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"dir_a","dir_b"},{arg.dir_a,arg.dir_b},
        {"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "perpendicular_plane_plane_" .. tostring(counter("perpendicular_plane_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = abs(angle_plane_plane(arg.dir_a,arg.dir_b)),
        target      = pi/constant(2.0),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

-- PARALLEL
function Parallel_line_line(arg)
    local msg="This function is called as follows:\n" ..
        "Parallel_line_line{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   dir_a       = ...   [Direction vector of line a] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of line a] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"dir_a","dir_b"},{arg.dir_a,arg.dir_b},
        {"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "parallel_line_line_" .. tostring(counter("parallel_line_line"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = angle_line_line(arg.dir_a,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Parallel_plane_line(arg)
    Parallel_line_plane{}
end

function Parallel_line_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Parallel_line_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   dir_a       = ...   [Direction vector of the line] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of the plane] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"dir_a","dir_b"},{arg.dir_a,arg.dir_b},
        {"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "parallel_line_plane_" .. tostring(counter("parallel_line_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = angle_line_plane(arg.dir_a,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Parallel_plane_plane(arg)
    local msg="This function is called as follows:\n" ..
        "Parallel_plane_plane{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   dir_a       = ...   [Direction vector of plane a] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of plane b] (vector)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    namedcheck({"dir_a","dir_b"},{arg.dir_a,arg.dir_b},
        {"expression_vector","expression_vector"}, msg)

    if arg.name==nil then
        arg.name = "parallel_plane_plane_" .. tostring(counter("parallel_plane_plane"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end
    
    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = angle_plane_plane(arg.dir_a,arg.dir_b),
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

-- TANGENT
function Tangent_cylinder_line(arg)
    Tangent_line_cylinder{}
end    

function Tangent_line_cylinder(arg)
    local msg="This function is called as follows:\n" ..
        "Tangent_line_cylinder{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on the line] (vector)\n" ..
        "   dir_a       = ...   [Direction vector of the line] (vector)\n" ..
        "   point_b     = ...   [A point on the center line of the cylinder] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of the center line of the cylinder] (vector)\n" ..
        "   r           = ...   [Radius of the cylinder] (positive scalar)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    if arg.r<0 then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","point_b","dir_b","r"},{arg.point_a,arg.dir_a,arg.point_b,arg.dir_b,arg.r},
        {"expression_vector","expression_vector","expression_vector","expression_vector","expression_double|number"}, msg)

    if extendedtype(arg.r)=="number" then
        arg.r = constant(arg.r)
    end 
    if arg.name==nil then
        arg.name = "tangent_line_cylinder_" .. tostring(counter("tangent_line_cylinder"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_line_line(arg.point_a, arg.dir_a, arg.point_b ,arg.dir_b),
        target      = arg.r,
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Tangent_cylinder_plane(arg)
    Tangent_plane_cylinder{}
end 

function Tangent_plane_cylinder(arg)
    local msg="This function is called as follows:\n" ..
        "Tangent_plane_cylinder{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on the plane] (vector)\n" ..
        "   dir_a       = ...   [Normal vector of the plane] (vector)\n" ..
        "   point_b     = ...   [A point on the center line of the cylinder] (vector)\n" ..
        "   dir_b       = ...   [Direction vector of the center line of the cylinder] (vector)\n" ..
        "   r           = ...   [Radius of the cylinder] (positive scalar)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    if arg.r<0 then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","point_b","dir_b","r"},{arg.point_a,arg.dir_a,arg.point_b,arg.dir_b,arg.r},
        {"expression_vector","expression_vector","expression_vector","expression_vector","expression_double|number"}, msg)

    if extendedtype(arg.r)=="number" then
        arg.r = constant(arg.r)
    end 
    if arg.name==nil then
        arg.name = "tangent_plane_cylinder_" .. tostring(counter("tangent_plane_cylinder"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_line_plane(arg.point_b, arg.dir_b, arg.point_a, arg.dir_a),
        target      = arg.r,
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Tangent_sphere_line(arg)
    Tangent_line_sphere{}
end 

function Tangent_line_sphere(arg)
    local msg="This function is called as follows:\n" ..
        "Tangent_line_sphere{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on the line] (vector)\n" ..
        "   dir_a       = ...   [Direction vector of the line] (vector)\n" ..
        "   center      = ...   [Center point of the sphere] (vector)\n" ..
        "   r           = ...   [Radius of the sphere] (positive scalar)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    if arg.r<0 then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","center","r"},{arg.point_a,arg.dir_a,arg.center,arg.r},
        {"expression_vector","expression_vector","expression_vector","expression_double|number"}, msg)

    if arg.name==nil then
        arg.name = "tangent_line_sphere_" .. tostring(counter("tangent_line_sphere"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_point_line(arg.center,arg.point_a,arg.dir_a),
        target      = arg.r,
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

function Tangent_sphere_plane(arg)
    Tangent_plane_sphere{}
end 

function Tangent_plane_sphere(arg)
    local msg="This function is called as follows:\n" ..
        "Tangent_plane_sphere{\n"..
        "   context     = ... \n" ..
        "   name        = ...   [optional, default_name<nr>]\n" ..
        "   K           = ...   [optional, defaultK] (scalar)\n" ..
        "   weight      = ...   [optional, defaultweight] (scalar)\n" ..
        "   priority    = ...   [optional, defaultpriority]\n"..
        "   point_a     = ...   [A point on the plane] (vector)\n" ..
        "   dir_a       = ...   [Normal vector of the plane] (vector)\n" ..
        "   center      = ...   [Center point of the sphere] (vector)\n" ..
        "   r           = ...   [Radius of the sphere] (positive scalar)\n" ..
        "}\n ";
    if arg==nil then
        print(msg)
        return
    end
    if arg.r<0 then
        print(msg)
        return
    end
    namedcheck({"point_a","dir_a","center","r"},{arg.point_a,arg.dir_a,arg.center,arg.r},
        {"expression_vector","expression_vector","expression_vector","expression_double|number"}, msg)

    if arg.name==nil then
        arg.name = "tangent_plane_sphere_" .. tostring(counter("tangent_plane_sphere"))
    end
    if arg.K==nil then
        arg.K = 4
    end
    if arg.weight==nil then
        arg.weight = constant(1.0)
    end
    if arg.priority==nil then
        arg.priority = 2
    end

    Constraint{
        context     = arg.context,
        name        = arg.name,
        expr        = distance_point_plane(arg.center,arg.point_a,arg.dir_a),
        target      = arg.r,
        K           = arg.K,
        weight      = arg.weight,
        priority    = arg.priority
    }
end

local ftable={
    translate_x                 =   translate_x,
    translate_y                 =   translate_y,
    translate_z                 =   translate_z,
    rotate_x                    =   rotate_x,
    rotate_y                    =   rotate_y,
    rotate_z                    =   rotate_z,
    angle_line_line             =   angle_line_line,
    angle_line_plane            =   angle_line_plane,
    angle_plane_plane           =   angle_plane_plane,
    distance_point_point        =   distance_point_point,
    distance_point_line         =   distance_point_line,
    distance_line_line          =   distance_line_line,
    distance_point_plane        =   distance_point_plane,
    distance_line_plane         =   distance_line_plane,
    distance_plane_plane        =   distance_plane_plane,
    Coincident_point_point      =   Coincident_point_point,
    Coincident_point_line       =   Coincident_point_line,
    Coincident_point_plane      =   Coincident_point_plane,
    Coincident_line_line        =   Coincident_line_line,
    Coincident_line_plane       =   Coincident_line_plane,
    Coincident_plane_plane      =   Coincident_plane_plane,
    Concentric                  =   Concentric,
    Perpendicular_line_line     =   Perpendicular_line_line,
    Perpendicular_line_plane    =   Perpendicular_line_plane,
    Perpendicular_plane_plane   =   Perpendicular_plane_plane,
    Parallel_line_line          =   Parallel_line_line,
    Parallel_line_plane         =   Parallel_line_plane,
    Parallel_plane_plane        =   Parallel_plane_plane,
    Tangent_line_cylinder       =   Tangent_line_cylinder,
    Tangent_plane_cylinder      =   Tangent_plane_cylinder,
    Tangent_line_sphere         =   Tangent_line_sphere,
    Tangent_plane_sphere        =   Tangent_plane_sphere
}

ftable['contents'] = _contents(ftable,'geometric3')
ftable['help']     = _help(ftable,'geometric3')

return ftable