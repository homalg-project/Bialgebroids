#! @BeginChunk group-like

LoadPackage( "Bialgebroid" );

#! @Example
q := RightQuiver( "q(1)[g:1->1,h:1->1]" );
#! q(1)[g:1->1,h:1->1]
Q := HomalgFieldOfRationals( );
#! Q
Qq := PathAlgebra( Q, q );
#! Q * q
B := Algebroid( Qq, [ Qq.h * Qq.g - Qq.1, Qq.g * Qq.h - Qq.1 ] );
#! Algebra generated by the right quiver q(1)[g:1->1,h:1->1]

B2 := B^2;
#! Algebra generated by the right quiver qxq(1x1)[1xg:1x1->1x1,
#! 1xh:1x1->1x1,gx1:1x1->1x1,hx1:1x1->1x1]

counit_rec := rec( g := 1, h := 1 );;
comult_rec := rec( g := PreCompose( B2.1xg, B2.gx1 ),
                   h := PreCompose( B2.1xh, B2.hx1 ) );;
AddBialgebroidStructure( B, counit_rec, comult_rec );
#! Bialgebra generated by the right quiver q(1)[g:1->1,h:1->1]

counit := Counit( B );
#! Functor from finitely presented Bialgebra generated by the right quiver
#! q(1)[g:1->1,h:1->1] -> Algebra generated by the right quiver *(1)[]

comult := Comultiplication( B );
#! Functor from finitely presented Bialgebra generated by the right quiver
#! q(1)[g:1->1,h:1->1] -> Algebra generated by the right quiver
#! qxq(1x1)[1xg:1x1->1x1,1xh:1x1->1x1,gx1:1x1->1x1,hx1:1x1->1x1]

antipode_rec := rec( g := B.h, h := B.g );;
AddAntipode(B, antipode_rec );
B;
#! Hopf algebra generated by the right quiver q(1)[g:1->1,h:1->1]

Antipode(B);
#! Contravariant functor from finitely presented Hopf algebra generated by the
#! right quiver q(1)[g:1->1,h:1->1] -> Hopf algebra generated by the
#! right quiver q(1)[g:1->1,h:1->1]


ApplyFunctor( counit, B.g );
#! (1)-[1*(1)]->(1)

#! @EndExample
#! @EndChunk
