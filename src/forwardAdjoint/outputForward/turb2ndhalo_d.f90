   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
   !
   !  Differentiation of turb2ndhalo in forward (tangent) mode (with options i4 dr8 r8):
   !   variations   of useful results: *rev *w
   !   with respect to varying inputs: *rev *w
   !   Plus diff mem management of: rev:in w:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          turb2ndHalo.f90                                 *
   !      * Author:        Edwin van der Weide                             *
   !      * Starting date: 06-16-2003                                      *
   !      * Last modified: 06-12-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE TURB2NDHALO_D(nn)
   !
   !      ******************************************************************
   !      *                                                                *
   !      * turb2ndHalo sets the turbulent variables in the second halo    *
   !      * cell for the given subface. Simple constant extrapolation is   *
   !      * used to avoid problems.                                        *
   !      *                                                                *
   !      ******************************************************************
   !
   USE BLOCKPOINTERS_D
   USE BCTYPES
   USE FLOWVARREFSTATE
   IMPLICIT NONE
   !
   !      Subroutine arguments.
   !
   INTEGER(kind=inttype), INTENT(IN) :: nn
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: i, j, l
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww0, ww1
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ww0d, ww1d
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rrev0, rrev1
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: rrev0d, rrev1d
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Determine the face on which this subface is located and set
   ! some pointers accordingly.
   SELECT CASE  (bcfaceid(nn)) 
   CASE (imin) 
   ww0d => wd(0, 1:, 1:, :)
   ww0 => w(0, 1:, 1:, :)
   ww1d => wd(1, 1:, 1:, :)
   ww1 => w(1, 1:, 1:, :)
   IF (eddymodel) THEN
   rrev0d => revd(0, 1:, 1:)
   rrev0 => rev(0, 1:, 1:)
   rrev1d => revd(1, 1:, 1:)
   rrev1 => rev(1, 1:, 1:)
   END IF
   CASE (imax) 
   !===============================================================
   ww0d => wd(ib, 1:, 1:, :)
   ww0 => w(ib, 1:, 1:, :)
   ww1d => wd(ie, 1:, 1:, :)
   ww1 => w(ie, 1:, 1:, :)
   IF (eddymodel) THEN
   rrev0d => revd(ib, 1:, 1:)
   rrev0 => rev(ib, 1:, 1:)
   rrev1d => revd(ie, 1:, 1:)
   rrev1 => rev(ie, 1:, 1:)
   END IF
   CASE (jmin) 
   !===============================================================
   ww0d => wd(1:, 0, 1:, :)
   ww0 => w(1:, 0, 1:, :)
   ww1d => wd(1:, 1, 1:, :)
   ww1 => w(1:, 1, 1:, :)
   IF (eddymodel) THEN
   rrev0d => revd(1:, 0, 1:)
   rrev0 => rev(1:, 0, 1:)
   rrev1d => revd(1:, 1, 1:)
   rrev1 => rev(1:, 1, 1:)
   END IF
   CASE (jmax) 
   !===============================================================
   ww0d => wd(1:, jb, 1:, :)
   ww0 => w(1:, jb, 1:, :)
   ww1d => wd(1:, je, 1:, :)
   ww1 => w(1:, je, 1:, :)
   IF (eddymodel) THEN
   rrev0d => revd(1:, jb, 1:)
   rrev0 => rev(1:, jb, 1:)
   rrev1d => revd(1:, je, 1:)
   rrev1 => rev(1:, je, 1:)
   END IF
   CASE (kmin) 
   !===============================================================
   ww0d => wd(1:, 1:, 0, :)
   ww0 => w(1:, 1:, 0, :)
   ww1d => wd(1:, 1:, 1, :)
   ww1 => w(1:, 1:, 1, :)
   IF (eddymodel) THEN
   rrev0d => revd(1:, 1:, 0)
   rrev0 => rev(1:, 1:, 0)
   rrev1d => revd(1:, 1:, 1)
   rrev1 => rev(1:, 1:, 1)
   END IF
   CASE (kmax) 
   !===============================================================
   ww0d => wd(1:, 1:, kb, :)
   ww0 => w(1:, 1:, kb, :)
   ww1d => wd(1:, 1:, ke, :)
   ww1 => w(1:, 1:, ke, :)
   IF (eddymodel) THEN
   rrev0d => revd(1:, 1:, kb)
   rrev0 => rev(1:, 1:, kb)
   rrev1d => revd(1:, 1:, ke)
   rrev1 => rev(1:, 1:, ke)
   END IF
   END SELECT
   ! Loop over the faces of the subface.
   DO j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
   DO i=bcdata(nn)%icbeg,bcdata(nn)%icend
   ! Loop over the turbulent variables and set the second halo
   ! value. If this is an eddy model, also set the eddy viscosity.
   DO l=nt1,nt2
   ww0d(i, j, l) = ww1d(i, j, l)
   ww0(i, j, l) = ww1(i, j, l)
   END DO
   IF (eddymodel) THEN
   rrev0d(i, j) = rrev1d(i, j)
   rrev0(i, j) = rrev1(i, j)
   END IF
   END DO
   END DO
   END SUBROUTINE TURB2NDHALO_D
