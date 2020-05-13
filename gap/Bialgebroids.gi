#
# Bialgebroids: Bialgebroids as algeroids with more structure
#
# Implementations
#

####################################
#
# methods for constructors:
#
####################################

##
InstallMethod( AddBialgebroidStructure,
        "for an algebroid and two records",
        [ IsAlgebroid, IsRecord, IsRecord ],
        
  function( B, counit_images, comult_images )
    local vertices, B0, counit_record_morphisms, counit_record_objects, counit_functor, B2, comult_record_morphisms, comult_record_objects, comult_functor, a;
    
    B!.Name := Concatenation( "Bia", B!.Name{[ 2 .. Length( B!.Name ) ]} );
    
    vertices := List( Vertices( UnderlyingQuiver( B ) ), String );
    
    B0 := B^0;
    
    # Construct the counit as a CapFunctor from B to B^0
    
    counit_record_morphisms := ShallowCopy( counit_images );
    counit_record_objects := rec();
  
    for a in NamesOfComponents( counit_images ) do
        if not IsCapCategoryMorphism( counit_images.(a) ) then
            counit_record_morphisms.(a) := counit_images.(a) * IdentityMorphism( B0.1 );
        fi;
    od;
    
    ## we know how to map the objects
    for a in vertices do
        counit_record_objects.(a) := B0.1;
    od;
   
    counit_functor := CapFunctor( B, counit_record_objects, counit_record_morphisms );
    
    if not IsIdenticalObj( B0, AsCapCategory( Range( counit_functor ) ) ) then
        Error( "counit_functor has a the wrong target category\n" );
    fi;
    
    SetCounit( B, counit_functor );
    
    B2 := B^2;
    
    # Construct the comultiplication as a CapFunctor from B to B^2
   
    comult_record_morphisms := ShallowCopy( comult_images );
    comult_record_objects := rec();
    
    ## we know how to map the objects
    for a in vertices do
        comult_record_objects.(a) := ElementaryTensor( B.(a), B.(a), B2 );
    od;
    
    comult_functor := CapFunctor( B, comult_record_objects, comult_record_morphisms );
    
    if not IsIdenticalObj( B2, AsCapCategory( Range( comult_functor ) ) ) then
        Error( "comult_functor has a the wrong target category\n" );
    fi;
    
    SetComultiplication( B, comult_functor );
    
    SetFilterObj( B, IsBialgebroid );
    
    return B;
    
end );

##
InstallMethod( AddAntipode,
        "for a CAP category and a record",
        [ IsAlgebroid, IsRecord ],
        
  function( B, S_images_of_generating_morphisms )
    local vertices, S_images_of_objects, S_functor, a;
    
    if IsAlgebraAsCategory(B) then
        B!.Name := Concatenation( "Hopf algebra", B!.Name{[ 10 .. Length( B!.Name ) ]} );
    else
        B!.Name := Concatenation( "Hopf algebroid", B!.Name{[ 10 .. Length( B!.Name ) ]} );
    fi;
    
    vertices := List( Vertices( UnderlyingQuiver( B ) ), String );
    
    S_images_of_objects := rec();
    for a in vertices do
        S_images_of_objects.(a) := B.(a);
    od;
    
    S_functor := CapFunctor( B, S_images_of_objects, S_images_of_generating_morphisms, false );
    
    S_functor!.Name := Concatenation( "Contravariant f", S_functor!.Name{[ 2 .. Length( S_functor!.Name ) ]} );
    
    if not IsIdenticalObj( B, AsCapCategory( Range( S_functor ) ) ) then
        Error( "S_functor has a the wrong target category\n" );
    fi;
    
    SetAntipode( B, S_functor );
    
end );

####################################
#
# methods for properties:
#
####################################

##
InstallMethod( IsCoassociative,
        "for an Algebroid",
        [ IsBialgebroid ],
    
  function( B )
    local vertices, comult, comult_times_id, id_times_comult, comult_times_id_after_comult, id_times_comult_after_comult, objects, morphisms, comult_times_id_after_comult_of_m, id_times_comult_after_comult_of_m, underlying_quiver_algebra_element_of_comult_times_id_after_comult_of_m, underlying_quiver_algebra_element_of_id_times_comult_after_comult_of_m, algebra_1, algebra_2, iso1, iso2, m;
    
    vertices := Vertices( UnderlyingQuiver( B ) );

    comult := Comultiplication(B);

    comult_times_id := TensorProductOnMorphisms( comult, IdentityFunctor(B) );
    id_times_comult := TensorProductOnMorphisms( IdentityFunctor(B), comult );
    
    comult_times_id_after_comult := PostCompose( comult_times_id, comult );
    id_times_comult_after_comult := PostCompose( id_times_comult, comult );

    objects := SetOfObjects(B);
    morphisms := SetOfGeneratingMorphisms(B);

    for m in morphisms do

        comult_times_id_after_comult_of_m := ApplyFunctor(comult_times_id_after_comult, m);
        id_times_comult_after_comult_of_m := ApplyFunctor(id_times_comult_after_comult, m);

        underlying_quiver_algebra_element_of_comult_times_id_after_comult_of_m := UnderlyingQuiverAlgebraElement(comult_times_id_after_comult_of_m);
        underlying_quiver_algebra_element_of_id_times_comult_after_comult_of_m := UnderlyingQuiverAlgebraElement(id_times_comult_after_comult_of_m);

        algebra_1 := AlgebraOfElement(underlying_quiver_algebra_element_of_comult_times_id_after_comult_of_m);
        algebra_2 := AlgebraOfElement(underlying_quiver_algebra_element_of_id_times_comult_after_comult_of_m);

        iso1 := IsomorphismToFlatTensorProduct(algebra_1);
        iso2 := IsomorphismToFlatTensorProduct(algebra_2);

        if not ImageElm( iso1, underlying_quiver_algebra_element_of_comult_times_id_after_comult_of_m) = ImageElm( iso2, underlying_quiver_algebra_element_of_id_times_comult_after_comult_of_m) then

            return false;

        fi;

    od;
    return true;
end );

InstallMethod( IsCoassociative,
        "for an algebroid",
        [ IsCategoryOfAlgebroidsObject ],
  function( B )
    local B_as_category, comult_as_functor, comult, comult_times_id, id_times_comult, comult_times_id_after_comult, id_times_comult_after_comult;

    B_as_category := AsCapCategory( B );

    if not HasComultiplication( B_as_category ) then
      Error( "algebroid does not have a comultiplication" );
    fi;

    comult_as_functor := Comultiplication(B_as_category);
    comult := CategoryOfAlgebroidsMorphism( comult_as_functor );

    comult_times_id := TensorProductOnMorphisms( comult, IdentityMorphism(B) );
    id_times_comult := TensorProductOnMorphisms( IdentityMorphism(B), comult );
    
    comult_times_id_after_comult := PostCompose( [ AssociatorLeftToRight(B,B,B), comult_times_id, comult ] );
    id_times_comult_after_comult := PostCompose( id_times_comult, comult );

    return IsCongruentForMorphisms( comult_times_id_after_comult, id_times_comult_after_comult );
end );

##
InstallMethod( IsCounitary,
        "for a commutative bialgebra",
        [ IsAlgebraAsCategory and IsCommutative and IsBialgebroid ],
        
  function( B )
    local comult, counit, mult, unit, idB, comp1, comp2, objects, morphisms, o, m;

    comult := Comultiplication( B );
    counit := Counit( B );
    
    mult := Multiplication( B );
    unit := Unit( B );
    
    idB := IdentityFunctor( B );

    comp1 := PreCompose( [ comult, TensorProductOnMorphisms( counit, idB ), TensorProductOnMorphisms( unit, idB ), mult ] );
    comp2 := PreCompose( [ comult, TensorProductOnMorphisms( idB, counit ), TensorProductOnMorphisms( idB, unit ), mult ] );
    
    objects := SetOfObjects( B );
    morphisms := SetOfGeneratingMorphisms( B );
    
    for o in SetOfObjects( B ) do

        if not ( ( IsEqualForObjects( ApplyFunctor(comp1, o), o ) ) and ( IsEqualForObjects( ApplyFunctor(comp2, o), o ) ) ) then

            return false;

        fi;

    od;

    for m in SetOfGeneratingMorphisms( B ) do

        if not ( ( IsEqualForMorphisms( ApplyFunctor(comp1, m), m ) ) and ( IsEqualForMorphisms( ApplyFunctor(comp2, m), m ) ) ) then

            return false;

        fi;

    od;
    
    return true;
    
end );

##
InstallMethod( IsCounitary,
        "for a commutative bialgebra",
        [ IsCategoryOfAlgebroidsObject ],
  function( B )
    local B2, I, B_as_category, comult, counit, id, comp1, comp2;
    B2 := TensorProductOnObjects( B, B );
    I := TensorUnit( CapCategory( B ) );
    
    B_as_category := AsCapCategory( B );
    
    if not HasComultiplication( B_as_category ) then
      Error( "algebroid does not have a comultiplication" );
    fi;
    
    comult := CategoryOfAlgebroidsMorphism( B, Comultiplication( B_as_category ), B2 );
    
    if not HasCounit( B_as_category ) then
      Error( "algebroid does not have a counit" );
    fi;
    
    counit := CategoryOfAlgebroidsMorphism( B, Counit( B_as_category ), I);
    
    id := IdentityMorphism( B );
    comp1 := PreCompose( [ comult, TensorProductOnMorphisms( counit, id ), LeftUnitor( B ) ] );
    comp2 := PreCompose( [ comult, TensorProductOnMorphisms( id, counit ), RightUnitor( B ) ] );
    
    return IsCongruentForMorphisms(comp1, id) and IsCongruentForMorphisms(comp2,id);
end );

##
InstallMethod( IsCocommutative,
         "for a bialgebra",
        [ IsBialgebroid ],
  function( B )
    local comult, twist_after_comult, objects, morphisms, o, m;
    
    comult := Comultiplication( B );
    
    twist_after_comult := PreCompose( [ comult, Twist( B, B ) ] );
    
    objects := SetOfObjects( B );
    morphisms := SetOfGeneratingMorphisms( B );
    
    for o in SetOfObjects( B ) do
        
        if not IsEqualForObjects( ApplyFunctor(twist_after_comult, o), ApplyFunctor(comult, o) ) then
            
            return false;
            
        fi;
        
    od;
    
    for m in SetOfGeneratingMorphisms( B ) do
        
        if not IsEqualForMorphisms( ApplyFunctor(twist_after_comult, m), ApplyFunctor(comult, m ) ) then
            
            return false;
            
        fi;
    od;
    
    return true;
end );

##
InstallMethod( IsHopfAlgebroid,
        "for commutative bialgebra",
        [ IsAlgebraAsCategory and IsCommutative and IsBialgebroid ],
  function( B )
    local comult, counit, antipode, mult, unit, idB, composition1, composition2, unit_after_counit, objects, morphisms, o, m;
    
    comult := Comultiplication( B );
    counit := Counit( B );
    
    mult := Multiplication( B );
    unit := Unit( B );

    antipode := Antipode( B );
    
    idB := IdentityFunctor( B );

    composition1 := PreCompose( [ comult, TensorProductOnMorphisms( antipode, idB ), mult ] );
    composition2 := PreCompose( [ comult, TensorProductOnMorphisms( idB, antipode ), mult ] );
    
    unit_after_counit := PreCompose( counit, unit);

    objects := SetOfObjects( B );
    morphisms := SetOfGeneratingMorphisms( B );
    
    for o in SetOfObjects( B ) do

        if not ( IsEqualForObjects( ApplyFunctor(composition1, o), ApplyFunctor(unit_after_counit, o) ) and IsEqualForObjects( ApplyFunctor(composition2, o), ApplyFunctor(unit_after_counit, o) ) ) then

            return false;

        fi;

    od;

    for m in SetOfGeneratingMorphisms( B ) do

        if not ( IsEqualForMorphisms( ApplyFunctor(composition1, m), ApplyFunctor(unit_after_counit, m ) ) and IsEqualForMorphisms( ApplyFunctor(composition2, m), ApplyFunctor(unit_after_counit, m) ) ) then

            return false;

        fi;

    od;
    
    return true;
end );
