   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
   !
   !  Differentiation of resetpp3pp4bwd in reverse (adjoint) mode (with options i4 dr8 r8 noISIZE):
   !   gradient     of useful results: *p pp3 pp4
   !   with respect to varying inputs: *p pp3 pp4
   !   Plus diff mem management of: p:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          resetpp3pp4Bwd.f90                              *
   !      * Author:        Eirikur Jonsson, Peter Zhoujie Lyu              *
   !      * Starting date: 10-14-2014                                      *
   !      * Last modified: 10-21-2014                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE RESETPP3PP4BWD_B(nn, pp3, pp3b, pp4, pp4b)
   USE BCTYPES
   USE BLOCKPOINTERS_B
   USE FLOWVARREFSTATE
   IMPLICIT NONE
   !
   !      Subroutine arguments.
   !
   INTEGER(kind=inttype), INTENT(IN) :: nn
   REAL(kind=realtype), DIMENSION(imaxdim, jmaxdim) :: pp3, pp4
   REAL(kind=realtype), DIMENSION(imaxdim, jmaxdim) :: pp3b, pp4b
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Determine the face id on which the subface is located and set
   ! the pointers accordinly.
   SELECT CASE  (bcfaceid(nn)) 
   CASE (imin) 
   pp4b(1:je, 1:ke) = pp4b(1:je, 1:ke) + pb(4, 1:je, 1:ke)
   pb(4, 1:je, 1:ke) = 0.0_8
   pp3b(1:je, 1:ke) = pp3b(1:je, 1:ke) + pb(3, 1:je, 1:ke)
   pb(3, 1:je, 1:ke) = 0.0_8
   CASE (imax) 
   pp4b(1:je, 1:ke) = pp4b(1:je, 1:ke) + pb(nx-1, 1:je, 1:ke)
   pb(nx-1, 1:je, 1:ke) = 0.0_8
   pp3b(1:je, 1:ke) = pp3b(1:je, 1:ke) + pb(nx, 1:je, 1:ke)
   pb(nx, 1:je, 1:ke) = 0.0_8
   CASE (jmin) 
   pp4b(1:ie, 1:ke) = pp4b(1:ie, 1:ke) + pb(1:ie, 4, 1:ke)
   pb(1:ie, 4, 1:ke) = 0.0_8
   pp3b(1:ie, 1:ke) = pp3b(1:ie, 1:ke) + pb(1:ie, 3, 1:ke)
   pb(1:ie, 3, 1:ke) = 0.0_8
   CASE (jmax) 
   pp4b(1:ie, 1:ke) = pp4b(1:ie, 1:ke) + pb(1:ie, ny-1, 1:ke)
   pb(1:ie, ny-1, 1:ke) = 0.0_8
   pp3b(1:ie, 1:ke) = pp3b(1:ie, 1:ke) + pb(1:ie, ny, 1:ke)
   pb(1:ie, ny, 1:ke) = 0.0_8
   CASE (kmin) 
   pp4b(1:ie, 1:je) = pp4b(1:ie, 1:je) + pb(1:ie, 1:je, 4)
   pb(1:ie, 1:je, 4) = 0.0_8
   pp3b(1:ie, 1:je) = pp3b(1:ie, 1:je) + pb(1:ie, 1:je, 3)
   pb(1:ie, 1:je, 3) = 0.0_8
   CASE (kmax) 
   pp4b(1:ie, 1:je) = pp4b(1:ie, 1:je) + pb(1:ie, 1:je, nz-1)
   pb(1:ie, 1:je, nz-1) = 0.0_8
   pp3b(1:ie, 1:je) = pp3b(1:ie, 1:je) + pb(1:ie, 1:je, nz)
   pb(1:ie, 1:je, nz) = 0.0_8
   END SELECT
   END SUBROUTINE RESETPP3PP4BWD_B
