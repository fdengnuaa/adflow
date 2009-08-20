!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
!  
!  Differentiation of timestepadj in reverse (adjoint) mode:
!   gradient, with respect to input variables: padj pinfcorradj
!                wadj sfacekadj skadj sfacejadj sjadj sfaceiadj
!                siadj adis
!   of linear combination of output variables: padj radkadj radjadj
!                wadj radiadj sfacekadj skadj sfacejadj sjadj sfaceiadj
!                siadj
!
!      ******************************************************************
!      *                                                                *
!      * File:          timeStepAdj.f90                                 *
!      * Author:        Edwin van der Weide,C.A.(Sandy) Mader           *
!      * Starting date: 08-05-2009                                      *
!      * Last modified: 08-05-2009                                      *
!      *                                                                *
!      ******************************************************************
!
SUBROUTINE TIMESTEPADJ_B(onlyradii, wadj, wadjb, padj, padjb, siadj, &
&  siadjb, sjadj, sjadjb, skadj, skadjb, sfaceiadj, sfaceiadjb, &
&  sfacejadj, sfacejadjb, sfacekadj, sfacekadjb, radiadj, radiadjb, &
&  radjadj, radjadjb, radkadj, radkadjb, icell, jcell, kcell, &
&  pinfcorradj, pinfcorradjb, rhoinfadj)
  USE blockpointers
  USE constants
  USE flowvarrefstate
  USE inputdiscretization
  USE inputiteration
  USE inputphysics
  USE inputtimespectral
  USE iteration
  USE section
  IMPLICIT NONE
!!$
!!$         enddo domains
!!$       enddo spectralLoop
  INTEGER(KIND=INTTYPE), INTENT(IN) :: icell
  INTEGER(KIND=INTTYPE), INTENT(IN) :: jcell
  INTEGER(KIND=INTTYPE), INTENT(IN) :: kcell
  LOGICAL, INTENT(IN) :: onlyradii
  REAL(KIND=REALTYPE) :: padj(-2:2, -2:2, -2:2), padjb(-2:2, -2:2, -2:2)
  REAL(KIND=REALTYPE) :: radiadj(-1:1, -1:1, -1:1), radiadjb(-1:1, -1:1&
&  , -1:1), radjadj(-1:1, -1:1, -1:1), radjadjb(-1:1, -1:1, -1:1), &
&  radkadj(-1:1, -1:1, -1:1), radkadjb(-1:1, -1:1, -1:1)
  REAL(KIND=REALTYPE) :: pinfcorradj, pinfcorradjb, rhoinfadj
  REAL(KIND=REALTYPE) :: sfaceiadj(-2:2, -2:2, -2:2), sfaceiadjb(-2:2, -&
&  2:2, -2:2), sfacejadj(-2:2, -2:2, -2:2), sfacejadjb(-2:2, -2:2, -2:2)&
&  , sfacekadj(-2:2, -2:2, -2:2), sfacekadjb(-2:2, -2:2, -2:2)
  REAL(KIND=REALTYPE) :: siadj(-3:2, -3:2, -3:2, 3), siadjb(-3:2, -3:2, &
&  -3:2, 3), sjadj(-3:2, -3:2, -3:2, 3), sjadjb(-3:2, -3:2, -3:2, 3), &
&  skadj(-3:2, -3:2, -3:2, 3), skadjb(-3:2, -3:2, -3:2, 3)
  REAL(KIND=REALTYPE), DIMENSION(-2:2, -2:2, -2:2, nw), INTENT(IN) :: &
&  wadj
  REAL(KIND=REALTYPE) :: wadjb(-2:2, -2:2, -2:2, nw)
  REAL(KIND=REALTYPE), PARAMETER :: b=2.0_realType
  REAL(KIND=REALTYPE) :: abs7, abs8, abs9
  INTEGER :: branch
  REAL(KIND=REALTYPE) :: dpi, dpib, dpj, dpjb, dpk, dpkb, rfl, vsi, vsj&
&  , vsk
  REAL(KIND=REALTYPE) :: dtladj
  INTEGER(KIND=INTTYPE) :: i, ii, j, jj, k, kk
  LOGICAL :: radiineeded
  REAL(KIND=REALTYPE) :: ri, rib, rij, rijb, rj, rjb, rjk, rjkb, rk, rkb&
&  , rki, rkib, temp3b3, temp3b4, temp3b5
  REAL(KIND=REALTYPE) :: sface, sfaceb, tmp
  REAL(KIND=REALTYPE) :: temp
  REAL(KIND=REALTYPE) :: abs1, abs1b, abs2, abs2b, abs3, abs3b, abs4, &
&  abs4b, abs5, abs5b, abs6, abs6b, cc2, cc2b, qs, qsb, rmu, sx, sxb, sy&
&  , syb, sz, szb, temp0, temp0b, temp1, temp1b0, temp2, temp2b0, tempb&
&  , ux, uxb, uy, uyb, uz, uzb
  REAL(KIND=REALTYPE) :: clim2, clim2b, plim, rlim, temp3, temp3b6, &
&  temp4, temp4b, temp5, temp5b
  REAL(KIND=REALTYPE) :: temp1b, temp2b, temp3b, temp3b0, temp3b1, &
&  temp3b2
  INTRINSIC MAX, ABS, SQRT
  EXTERNAL TERMINATE
!
!      ******************************************************************
!      *                                                                *
!      * timeStep computes the time step, or more precisely the time    *
!      * step divided by the volume per unit CFL, in the owned cells.   *
!      * However, for the artificial dissipation schemes, the spectral  *
!      * radIi in the halo's are needed. Therefore the loop is taken    *
!      * over the the first level of halo cells. The spectral radIi are *
!      * stored and possibly modified for high aspect ratio cells.      *
!      *                                                                *
!      ******************************************************************
!
!
!      Subroutine argument.
!
!
!      Local parameters.
!
!
!      Local variables.
!
!integer(kind=intType) :: sps, nn, i, j, k
!
!      ******************************************************************
!      *                                                                *
!      * Begin execution                                                *
!      *                                                                *
!      ******************************************************************
!
! Determine whether or not the spectral radii are needed for the
! flux computation.
  radiineeded = radiineededcoarse
  IF (currentlevel .LE. groundlevel) THEN
    radiineeded = radiineededfine
    CALL PUSHINTEGER4(1)
  ELSE
    CALL PUSHINTEGER4(0)
  END IF
! Return immediately if only the spectral radii must be computed
! and these are not needed for the flux computation.
  IF (onlyradii .AND. (.NOT.radiineeded)) THEN
    pinfcorradjb = 0.0
  ELSE
! Set the value of plim. To be fully consistent this must have
! the dimension of a pressure. Therefore a fraction of pInfCorr
! is used. Idem for rlim; compute clim2 as well.
    clim2 = 0.000001_realType*gammainf*pinfcorradj/rhoinfadj
! Loop over the number of spectral solutions and local blocks.
!moved outside
!!$       spectralLoop: do sps=1,nTimeIntervalsSpectral
!!$         domains: do nn=1,nDom
!!$
!!$           ! Set the pointers for this block.
!!$
!!$           call setPointers(nn, currentLevel, sps)
! Initialize sFace to zero. This value will be used if the
! block is not moving.
    sface = zero
!
!          **************************************************************
!          *                                                            *
!          * Inviscid contribution, depending on the preconditioner.    *
!          * Compute the cell centered values of the spectral radii.    *
!          *                                                            *
!          **************************************************************
!
    SELECT CASE  (precond) 
    CASE (noprecond) 
! No preconditioner. Simply the standard spectral radius.
! Loop over the cells, including the first level halo.
!!$               do k=1,ke
!!$                 do j=1,je
!!$                   do i=1,ie
      DO k=-1,1
        DO j=-1,1
          DO i=-1,1
            CALL PUSHINTEGER4(ii)
            ii = icell + i
            CALL PUSHINTEGER4(jj)
            jj = jcell + j
            CALL PUSHINTEGER4(kk)
            kk = kcell + k
            CALL PUSHREAL8(ux)
! Compute the velocities and speed of sound squared.
            ux = wadj(i, j, k, ivx)
            CALL PUSHREAL8(uy)
            uy = wadj(i, j, k, ivy)
            CALL PUSHREAL8(uz)
            uz = wadj(i, j, k, ivz)
            CALL PUSHREAL8(cc2)
            cc2 = gamma(ii, jj, kk)*padj(i, j, k)/wadj(i, j, k, irho)
            IF (cc2 .LT. clim2) THEN
              cc2 = clim2
              CALL PUSHINTEGER4(1)
            ELSE
              cc2 = cc2
              CALL PUSHINTEGER4(0)
            END IF
! Set the dot product of the grid velocity and the
! normal in i-direction for a moving face. To avoid
! a number of multiplications by 0.5 simply the sum
! is taken.
            IF (addgridvelocities) THEN
              sface = sfaceiadj(i-1, j, k) + sfaceiadj(i, j, k)
              CALL PUSHINTEGER4(1)
            ELSE
              CALL PUSHINTEGER4(0)
            END IF
            CALL PUSHREAL8(sx)
! Spectral radius in i-direction.
            sx = siadj(i-1, j, k, 1) + siadj(i, j, k, 1)
            CALL PUSHREAL8(sy)
            sy = siadj(i-1, j, k, 2) + siadj(i, j, k, 2)
            CALL PUSHREAL8(sz)
            sz = siadj(i-1, j, k, 3) + siadj(i, j, k, 3)
            qs = ux*sx + uy*sy + uz*sz - sface
            IF (sx .GT. zero .OR. sy .GT. zero .OR. sz .GT. zero) THEN
              IF (qs .GE. 0.) THEN
                abs1 = qs
                CALL PUSHINTEGER4(1)
              ELSE
                abs1 = -qs
                CALL PUSHINTEGER4(0)
              END IF
              radiadj(i, j, k) = half*(abs1+SQRT(cc2*(sx**2+sy**2+sz**2)&
&                ))
              CALL PUSHINTEGER4(0)
            ELSE
              IF (qs .GE. 0.) THEN
                abs2 = qs
                CALL PUSHINTEGER4(1)
              ELSE
                abs2 = -qs
                CALL PUSHINTEGER4(0)
              END IF
              radiadj(i, j, k) = half*abs2
              CALL PUSHINTEGER4(1)
            END IF
! The grid velocity in j-direction.
            IF (addgridvelocities) THEN
              sface = sfacejadj(i, j-1, k) + sfacejadj(i, j, k)
              CALL PUSHINTEGER4(1)
            ELSE
              CALL PUSHINTEGER4(0)
            END IF
            CALL PUSHREAL8(sx)
! Spectral radius in j-direction.
            sx = sjadj(i, j-1, k, 1) + sjadj(i, j, k, 1)
            CALL PUSHREAL8(sy)
            sy = sjadj(i, j-1, k, 2) + sjadj(i, j, k, 2)
            CALL PUSHREAL8(sz)
            sz = sjadj(i, j-1, k, 3) + sjadj(i, j, k, 3)
            qs = ux*sx + uy*sy + uz*sz - sface
            IF (sx .GT. zero .OR. sy .GT. zero .OR. sz .GT. zero) THEN
              IF (qs .GE. 0.) THEN
                abs3 = qs
                CALL PUSHINTEGER4(1)
              ELSE
                abs3 = -qs
                CALL PUSHINTEGER4(0)
              END IF
              radjadj(i, j, k) = half*(abs3+SQRT(cc2*(sx**2+sy**2+sz**2)&
&                ))
              CALL PUSHINTEGER4(0)
            ELSE
              IF (qs .GE. 0.) THEN
                abs4 = qs
                CALL PUSHINTEGER4(1)
              ELSE
                abs4 = -qs
                CALL PUSHINTEGER4(0)
              END IF
              radjadj(i, j, k) = half*abs4
              CALL PUSHINTEGER4(1)
            END IF
! The grid velocity in k-direction.
            IF (addgridvelocities) THEN
              sface = sfacekadj(i, j, k-1) + sfacekadj(i, j, k)
              CALL PUSHINTEGER4(1)
            ELSE
              CALL PUSHINTEGER4(0)
            END IF
            CALL PUSHREAL8(sx)
! Spectral radius in k-direction.
            sx = skadj(i, j, k-1, 1) + skadj(i, j, k, 1)
            CALL PUSHREAL8(sy)
            sy = skadj(i, j, k-1, 2) + skadj(i, j, k, 2)
            CALL PUSHREAL8(sz)
            sz = skadj(i, j, k-1, 3) + skadj(i, j, k, 3)
            qs = ux*sx + uy*sy + uz*sz - sface
            IF (sx .GT. zero .OR. sy .GT. zero .OR. sz .GT. zero) THEN
              IF (qs .GE. 0.) THEN
                abs5 = qs
                CALL PUSHINTEGER4(1)
              ELSE
                abs5 = -qs
                CALL PUSHINTEGER4(0)
              END IF
              radkadj(i, j, k) = half*(abs5+SQRT(cc2*(sx**2+sy**2+sz**2)&
&                ))
              CALL PUSHINTEGER4(1)
            ELSE
              IF (qs .GE. 0.) THEN
                abs6 = qs
                CALL PUSHINTEGER4(1)
              ELSE
                abs6 = -qs
                CALL PUSHINTEGER4(0)
              END IF
              radkadj(i, j, k) = half*abs6
              CALL PUSHINTEGER4(2)
            END IF
          END DO
        END DO
      END DO
      CALL PUSHINTEGER4(1)
    CASE (turkel) 
      CALL PUSHINTEGER4(2)
    CASE (choimerkle) 
      CALL PUSHINTEGER4(3)
    CASE DEFAULT
      CALL PUSHINTEGER4(0)
    END SELECT
!
!          **************************************************************
!          *                                                            *
!          * Adapt the spectral radii if directional scaling must be    *
!          * applied.                                                   *
!          *                                                            *
!          **************************************************************
!
    IF (dirscaling .AND. currentlevel .LE. groundlevel) THEN
! if( dirScaling ) then
      DO k=-1,1
        DO j=-1,1
          DO i=-1,1
            IF (radiadj(i, j, k) .LT. eps) THEN
              CALL PUSHREAL8(ri)
              ri = eps
              CALL PUSHINTEGER4(1)
            ELSE
              CALL PUSHREAL8(ri)
              ri = radiadj(i, j, k)
              CALL PUSHINTEGER4(0)
            END IF
            IF (radjadj(i, j, k) .LT. eps) THEN
              CALL PUSHREAL8(rj)
              rj = eps
              CALL PUSHINTEGER4(1)
            ELSE
              CALL PUSHREAL8(rj)
              rj = radjadj(i, j, k)
              CALL PUSHINTEGER4(0)
            END IF
            IF (radkadj(i, j, k) .LT. eps) THEN
              CALL PUSHREAL8(rk)
              rk = eps
              CALL PUSHINTEGER4(1)
            ELSE
              CALL PUSHREAL8(rk)
              rk = radkadj(i, j, k)
              CALL PUSHINTEGER4(0)
            END IF
            CALL PUSHREAL8(rij)
! Compute the scaling in the three coordinate
! directions.
            rij = (ri/rj)**adis
            CALL PUSHREAL8(rjk)
            rjk = (rj/rk)**adis
            CALL PUSHREAL8(rki)
            rki = (rk/ri)**adis
            CALL PUSHREAL8(radiadj(i, j, k))
! Create the scaled versions of the aspect ratios.
! Note that the multiplication is done with radi, radJ
! and radK, such that the influence of the clipping
! is negligible.
!   radi(i,j,k) = third*radi(i,j,k)*(one + one/rij + rki)
!   radJ(i,j,k) = third*radJ(i,j,k)*(one + one/rjk + rij)
!   radK(i,j,k) = third*radK(i,j,k)*(one + one/rki + rjk)
            radiadj(i, j, k) = radiadj(i, j, k)*(one+one/rij+rki)
            CALL PUSHREAL8(radjadj(i, j, k))
            radjadj(i, j, k) = radjadj(i, j, k)*(one+one/rjk+rij)
            CALL PUSHREAL8(radkadj(i, j, k))
            radkadj(i, j, k) = radkadj(i, j, k)*(one+one/rki+rjk)
          END DO
        END DO
      END DO
      CALL PUSHINTEGER4(1)
    ELSE
      CALL PUSHINTEGER4(0)
    END IF
! The rest of this file can be skipped if only the spectral
! radii need to be computed.
    IF (.NOT.onlyradii) THEN
! The viscous contribution, if needed.
      IF (viscous) THEN

      END IF
    END IF
    CALL POPINTEGER4(branch)
    IF (.NOT.branch .LT. 1) THEN
      DO k=1,-1,-1
        DO j=1,-1,-1
          DO i=1,-1,-1
            CALL POPREAL8(radkadj(i, j, k))
            temp3b0 = radkadj(i, j, k)*radkadjb(i, j, k)
            CALL POPREAL8(radjadj(i, j, k))
            CALL POPREAL8(radiadj(i, j, k))
            temp3b1 = radiadj(i, j, k)*radiadjb(i, j, k)
            rkib = temp3b1 - one*temp3b0/rki**2
            temp3b2 = radjadj(i, j, k)*radjadjb(i, j, k)
            rjkb = temp3b0 - one*temp3b2/rjk**2
            radkadjb(i, j, k) = (one+one/rki+rjk)*radkadjb(i, j, k)
            rijb = temp3b2 - one*temp3b1/rij**2
            radjadjb(i, j, k) = (one+one/rjk+rij)*radjadjb(i, j, k)
            radiadjb(i, j, k) = (one+one/rij+rki)*radiadjb(i, j, k)
            CALL POPREAL8(rki)
            IF (rkib .EQ. 0.0 .OR. rk/ri .LE. 0.0 .AND. (adis .EQ. 0.0 &
&                .OR. adis .NE. INT(adis))) THEN
              temp3b3 = 0.0
            ELSE
              temp3b3 = adis*(rk/ri)**(adis-1)*rkib/ri
            END IF
            IF (rjkb .EQ. 0.0 .OR. rj/rk .LE. 0.0 .AND. (adis .EQ. 0.0 &
&                .OR. adis .NE. INT(adis))) THEN
              temp3b4 = 0.0
            ELSE
              temp3b4 = adis*(rj/rk)**(adis-1)*rjkb/rk
            END IF
            rkb = temp3b3 - rj*temp3b4/rk
            IF (rijb .EQ. 0.0 .OR. ri/rj .LE. 0.0 .AND. (adis .EQ. 0.0 &
&                .OR. adis .NE. INT(adis))) THEN
              temp3b5 = 0.0
            ELSE
              temp3b5 = adis*(ri/rj)**(adis-1)*rijb/rj
            END IF
            rib = temp3b5 - rk*temp3b3/ri
            CALL POPREAL8(rjk)
            rjb = temp3b4 - ri*temp3b5/rj
            CALL POPREAL8(rij)
            CALL POPINTEGER4(branch)
            IF (branch .LT. 1) THEN
              CALL POPREAL8(rk)
              radkadjb(i, j, k) = radkadjb(i, j, k) + rkb
            ELSE
              CALL POPREAL8(rk)
            END IF
            CALL POPINTEGER4(branch)
            IF (branch .LT. 1) THEN
              CALL POPREAL8(rj)
              radjadjb(i, j, k) = radjadjb(i, j, k) + rjb
            ELSE
              CALL POPREAL8(rj)
            END IF
            CALL POPINTEGER4(branch)
            IF (branch .LT. 1) THEN
              CALL POPREAL8(ri)
              radiadjb(i, j, k) = radiadjb(i, j, k) + rib
            ELSE
              CALL POPREAL8(ri)
            END IF
          END DO
        END DO
      END DO
    END IF
    CALL POPINTEGER4(branch)
    IF (branch .LT. 2) THEN
      IF (branch .LT. 1) THEN
        clim2b = 0.0
      ELSE
        clim2b = 0.0
        sfaceb = 0.0
        DO k=1,-1,-1
          DO j=1,-1,-1
            DO i=1,-1,-1
              CALL POPINTEGER4(branch)
              IF (branch .LT. 2) THEN
                temp2 = sx**2 + sy**2 + sz**2
                temp3b = half*radkadjb(i, j, k)/(2.0*SQRT(cc2*temp2))
                temp2b0 = cc2*temp3b
                abs5b = half*radkadjb(i, j, k)
                cc2b = temp2*temp3b
                sxb = 2*sx*temp2b0
                syb = 2*sy*temp2b0
                szb = 2*sz*temp2b0
                radkadjb(i, j, k) = 0.0
                CALL POPINTEGER4(branch)
                IF (branch .LT. 1) THEN
                  qsb = -abs5b
                ELSE
                  qsb = abs5b
                END IF
              ELSE
                abs6b = half*radkadjb(i, j, k)
                radkadjb(i, j, k) = 0.0
                CALL POPINTEGER4(branch)
                IF (branch .LT. 1) THEN
                  qsb = -abs6b
                ELSE
                  qsb = abs6b
                END IF
                cc2b = 0.0
                sxb = 0.0
                syb = 0.0
                szb = 0.0
              END IF
              uxb = sx*qsb
              sxb = sxb + ux*qsb
              uyb = sy*qsb
              syb = syb + uy*qsb
              uzb = sz*qsb
              szb = szb + uz*qsb
              sfaceb = sfaceb - qsb
              CALL POPREAL8(sz)
              skadjb(i, j, k-1, 3) = skadjb(i, j, k-1, 3) + szb
              skadjb(i, j, k, 3) = skadjb(i, j, k, 3) + szb
              CALL POPREAL8(sy)
              skadjb(i, j, k-1, 2) = skadjb(i, j, k-1, 2) + syb
              skadjb(i, j, k, 2) = skadjb(i, j, k, 2) + syb
              CALL POPREAL8(sx)
              skadjb(i, j, k-1, 1) = skadjb(i, j, k-1, 1) + sxb
              skadjb(i, j, k, 1) = skadjb(i, j, k, 1) + sxb
              CALL POPINTEGER4(branch)
              IF (.NOT.branch .LT. 1) THEN
                sfacekadjb(i, j, k-1) = sfacekadjb(i, j, k-1) + sfaceb
                sfacekadjb(i, j, k) = sfacekadjb(i, j, k) + sfaceb
                sfaceb = 0.0
              END IF
              CALL POPINTEGER4(branch)
              IF (branch .LT. 1) THEN
                temp1 = sx**2 + sy**2 + sz**2
                temp2b = half*radjadjb(i, j, k)/(2.0*SQRT(cc2*temp1))
                temp1b0 = cc2*temp2b
                abs3b = half*radjadjb(i, j, k)
                cc2b = cc2b + temp1*temp2b
                sxb = 2*sx*temp1b0
                syb = 2*sy*temp1b0
                szb = 2*sz*temp1b0
                radjadjb(i, j, k) = 0.0
                CALL POPINTEGER4(branch)
                IF (branch .LT. 1) THEN
                  qsb = -abs3b
                ELSE
                  qsb = abs3b
                END IF
              ELSE
                abs4b = half*radjadjb(i, j, k)
                radjadjb(i, j, k) = 0.0
                CALL POPINTEGER4(branch)
                IF (branch .LT. 1) THEN
                  qsb = -abs4b
                ELSE
                  qsb = abs4b
                END IF
                sxb = 0.0
                syb = 0.0
                szb = 0.0
              END IF
              uxb = uxb + sx*qsb
              sxb = sxb + ux*qsb
              uyb = uyb + sy*qsb
              syb = syb + uy*qsb
              uzb = uzb + sz*qsb
              szb = szb + uz*qsb
              sfaceb = sfaceb - qsb
              CALL POPREAL8(sz)
              sjadjb(i, j-1, k, 3) = sjadjb(i, j-1, k, 3) + szb
              sjadjb(i, j, k, 3) = sjadjb(i, j, k, 3) + szb
              CALL POPREAL8(sy)
              sjadjb(i, j-1, k, 2) = sjadjb(i, j-1, k, 2) + syb
              sjadjb(i, j, k, 2) = sjadjb(i, j, k, 2) + syb
              CALL POPREAL8(sx)
              sjadjb(i, j-1, k, 1) = sjadjb(i, j-1, k, 1) + sxb
              sjadjb(i, j, k, 1) = sjadjb(i, j, k, 1) + sxb
              CALL POPINTEGER4(branch)
              IF (.NOT.branch .LT. 1) THEN
                sfacejadjb(i, j-1, k) = sfacejadjb(i, j-1, k) + sfaceb
                sfacejadjb(i, j, k) = sfacejadjb(i, j, k) + sfaceb
                sfaceb = 0.0
              END IF
              CALL POPINTEGER4(branch)
              IF (branch .LT. 1) THEN
                temp0 = sx**2 + sy**2 + sz**2
                temp1b = half*radiadjb(i, j, k)/(2.0*SQRT(cc2*temp0))
                temp0b = cc2*temp1b
                abs1b = half*radiadjb(i, j, k)
                cc2b = cc2b + temp0*temp1b
                sxb = 2*sx*temp0b
                syb = 2*sy*temp0b
                szb = 2*sz*temp0b
                radiadjb(i, j, k) = 0.0
                CALL POPINTEGER4(branch)
                IF (branch .LT. 1) THEN
                  qsb = -abs1b
                ELSE
                  qsb = abs1b
                END IF
              ELSE
                abs2b = half*radiadjb(i, j, k)
                radiadjb(i, j, k) = 0.0
                CALL POPINTEGER4(branch)
                IF (branch .LT. 1) THEN
                  qsb = -abs2b
                ELSE
                  qsb = abs2b
                END IF
                sxb = 0.0
                syb = 0.0
                szb = 0.0
              END IF
              uxb = uxb + sx*qsb
              sxb = sxb + ux*qsb
              uyb = uyb + sy*qsb
              syb = syb + uy*qsb
              uzb = uzb + sz*qsb
              szb = szb + uz*qsb
              sfaceb = sfaceb - qsb
              CALL POPREAL8(sz)
              siadjb(i-1, j, k, 3) = siadjb(i-1, j, k, 3) + szb
              siadjb(i, j, k, 3) = siadjb(i, j, k, 3) + szb
              CALL POPREAL8(sy)
              siadjb(i-1, j, k, 2) = siadjb(i-1, j, k, 2) + syb
              siadjb(i, j, k, 2) = siadjb(i, j, k, 2) + syb
              CALL POPREAL8(sx)
              siadjb(i-1, j, k, 1) = siadjb(i-1, j, k, 1) + sxb
              siadjb(i, j, k, 1) = siadjb(i, j, k, 1) + sxb
              CALL POPINTEGER4(branch)
              IF (.NOT.branch .LT. 1) THEN
                sfaceiadjb(i-1, j, k) = sfaceiadjb(i-1, j, k) + sfaceb
                sfaceiadjb(i, j, k) = sfaceiadjb(i, j, k) + sfaceb
                sfaceb = 0.0
              END IF
              CALL POPINTEGER4(branch)
              IF (.NOT.branch .LT. 1) THEN
                clim2b = clim2b + cc2b
                cc2b = 0.0
              END IF
              CALL POPREAL8(cc2)
              temp = wadj(i, j, k, irho)
              tempb = gamma(ii, jj, kk)*cc2b/temp
              padjb(i, j, k) = padjb(i, j, k) + tempb
              wadjb(i, j, k, irho) = wadjb(i, j, k, irho) - padj(i, j, k&
&                )*tempb/temp
              CALL POPREAL8(uz)
              wadjb(i, j, k, ivz) = wadjb(i, j, k, ivz) + uzb
              CALL POPREAL8(uy)
              wadjb(i, j, k, ivy) = wadjb(i, j, k, ivy) + uyb
              CALL POPREAL8(ux)
              wadjb(i, j, k, ivx) = wadjb(i, j, k, ivx) + uxb
              CALL POPINTEGER4(kk)
              CALL POPINTEGER4(jj)
              CALL POPINTEGER4(ii)
            END DO
          END DO
        END DO
      END IF
    ELSE IF (branch .LT. 3) THEN
      clim2b = 0.0
    ELSE
      clim2b = 0.0
    END IF
    pinfcorradjb = gammainf*0.000001_realType*clim2b/rhoinfadj
  END IF
  CALL POPINTEGER4(branch)
!  adisb = 0.0
END SUBROUTINE TIMESTEPADJ_B
