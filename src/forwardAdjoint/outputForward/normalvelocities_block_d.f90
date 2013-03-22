   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.6 (r4512) -  3 Aug 2012 15:11
   !
   !  Differentiation of normalvelocities_block in forward (tangent) mode (with options i4 dr8 r8):
   !   variations   of useful results: *(*bcdata.rface)
   !   with respect to varying inputs: *sfacei *sfacej *sfacek *si
   !                *sj *sk
   !   Plus diff mem management of: sfacei:in sfacej:in sfacek:in
   !                si:in sj:in sk:in bcdata:in *bcdata.rface:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          normalVelocities.f90                            *
   !      * Author:        Edwin van der Weide                             *
   !      * Starting date: 02-23-2004                                      *
   !      * Last modified: 06-12-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE NORMALVELOCITIES_BLOCK_D(sps)
   USE BLOCKPOINTERS_D
   USE BCTYPES
   USE ITERATION
   USE DIFFSIZES
   !  Hint: ISIZE1OFDrfbcdata should be the size of dimension 1 of array *bcdata
   IMPLICIT NONE
   !
   !      ******************************************************************
   !      *                                                                *
   !      * normalVelocitiesAllLevels computes the normal grid             *
   !      * velocities of some boundary faces of the moving blocks for     *
   !      * spectral mode sps. All grid levels from ground level to the    *
   !      * coarsest level are considered.                                 *
   !      *                                                                *
   !      ******************************************************************
   !
   !
   !      Subroutine arguments.
   !
   INTEGER(kind=inttype), INTENT(IN) :: sps
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: mm
   INTEGER(kind=inttype) :: i, j
   REAL(kind=realtype) :: weight, mult
   REAL(kind=realtype) :: weightd
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: sface
   REAL(kind=realtype), DIMENSION(:, :), POINTER :: sfaced
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ss
   REAL(kind=realtype), DIMENSION(:, :, :), POINTER :: ssd
   REAL(kind=realtype) :: arg1
   REAL(kind=realtype) :: arg1d
   INTEGER :: ii1
   INTRINSIC ASSOCIATED
   INTRINSIC SQRT
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Check for a moving block. As it is possible that in a
   ! multidisicplinary environment additional grid velocities
   ! are set, the test should be done on addGridVelocities
   ! and not on blockIsMoving.
   IF (addgridvelocities) THEN
   DO ii1=1,ISIZE1OFDrfbcdata
   bcdatad(ii1)%rface = 0.0_8
   END DO
   !
   !            ************************************************************
   !            *                                                          *
   !            * Determine the normal grid velocities of the boundaries.  *
   !            * As these values are based on the unit normal. A division *
   !            * by the length of the normal is needed.                   *
   !            * Furthermore the boundary unit normals are per definition *
   !            * outward pointing, while on the iMin, jMin and kMin       *
   !            * boundaries the face normals are inward pointing. This    *
   !            * is taken into account by the factor mult.                *
   !            *                                                          *
   !            ************************************************************
   !
   ! Loop over the boundary subfaces.
   bocoloop:DO mm=1,nbocos
   ! Check whether rFace is allocated.
   IF (ASSOCIATED(bcdata(mm)%rface)) THEN
   ! Determine the block face on which the subface is
   ! located and set some variables accordingly.
   SELECT CASE  (bcfaceid(mm)) 
   CASE (imin) 
   mult = -one
   ssd => sid(1, :, :, :)
   ss => si(1, :, :, :)
   sfaced => sfaceid(1, :, :)
   sface => sfacei(1, :, :)
   CASE (imax) 
   mult = one
   ssd => sid(il, :, :, :)
   ss => si(il, :, :, :)
   sfaced => sfaceid(il, :, :)
   sface => sfacei(il, :, :)
   CASE (jmin) 
   mult = -one
   ssd => sjd(:, 1, :, :)
   ss => sj(:, 1, :, :)
   sfaced => sfacejd(:, 1, :)
   sface => sfacej(:, 1, :)
   CASE (jmax) 
   mult = one
   ssd => sjd(:, jl, :, :)
   ss => sj(:, jl, :, :)
   sfaced => sfacejd(:, jl, :)
   sface => sfacej(:, jl, :)
   CASE (kmin) 
   mult = -one
   ssd => skd(:, :, 1, :)
   ss => sk(:, :, 1, :)
   sfaced => sfacekd(:, :, 1)
   sface => sfacek(:, :, 1)
   CASE (kmax) 
   mult = one
   ssd => skd(:, :, kl, :)
   ss => sk(:, :, kl, :)
   sfaced => sfacekd(:, :, kl)
   sface => sfacek(:, :, kl)
   END SELECT
   ! Loop over the faces of the subface.
   DO j=bcdata(mm)%jcbeg,bcdata(mm)%jcend
   DO i=bcdata(mm)%icbeg,bcdata(mm)%icend
   ! Compute the inverse of the length of the normal
   ! vector and possibly correct for inward pointing.
   arg1d = 2*ss(i, j, 1)*ssd(i, j, 1) + 2*ss(i, j, 2)*ssd(i, j&
   &              , 2) + 2*ss(i, j, 3)*ssd(i, j, 3)
   arg1 = ss(i, j, 1)**2 + ss(i, j, 2)**2 + ss(i, j, 3)**2
   IF (arg1 .EQ. 0.0_8) THEN
   weightd = 0.0_8
   ELSE
   weightd = arg1d/(2.0*SQRT(arg1))
   END IF
   weight = SQRT(arg1)
   IF (weight .GT. zero) THEN
   weightd = -(mult*weightd/weight**2)
   weight = mult/weight
   END IF
   ! Compute the normal velocity based on the outward
   ! pointing unit normal.
   bcdatad(mm)%rface(i, j) = weightd*sface(i, j) + weight*&
   &              sfaced(i, j)
   bcdata(mm)%rface(i, j) = weight*sface(i, j)
   END DO
   END DO
   END IF
   END DO bocoloop
   ELSE
   ! Block is not moving. Loop over the boundary faces and set
   ! the normal grid velocity to zero if allocated.
   DO mm=1,nbocos
   IF (ASSOCIATED(bcdata(mm)%rface)) THEN
   bcdatad(mm)%rface = 0.0_8
   bcdata(mm)%rface = zero
   END IF
   END DO
   DO ii1=1,ISIZE1OFDrfbcdata
   bcdatad(ii1)%rface = 0.0_8
   END DO
   END IF
   END SUBROUTINE NORMALVELOCITIES_BLOCK_D