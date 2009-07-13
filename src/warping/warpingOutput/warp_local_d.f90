!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade 3.1 (r2754) - 01/12/2009 09:43
!  
!  Differentiation of warp_local in forward (tangent) mode:
!   variations  of output variables: xyznew
!   with respect to input variables: xyznew
!
! ***********************************
! *  File: warp_local.f90
! *  Author: C.A.(Sandy) Mader
! *  Started: 12-07-2008
! *  Modified: 12-07-2008
! ***********************************
SUBROUTINE WARP_LOCAL_D(xyznew, xyznewd, xyz0, ifaceptb, iedgeptb, imax&
&  , jmax, kmax)
  USE blockpointers
  IMPLICIT NONE
  INTEGER(KIND=INTTYPE) :: imax, jmax, kmax
! Subroutine Arguments
  REAL(KIND=REALTYPE), DIMENSION(3, 0:imax+1, 0:jmax+1, 0:kmax+1) :: &
&  xyznew, xyz0
  REAL(KIND=REALTYPE), DIMENSION(3, 0:imax+1, 0:jmax+1, 0:kmax+1) :: &
&  xyznewd
  INTEGER(KIND=INTTYPE), DIMENSION(6) :: ifaceptb
  INTEGER(KIND=INTTYPE), DIMENSION(12) :: iedgeptb
! Local Variables
  REAL(KIND=REALTYPE), DIMENSION(:, :, :, :, :), ALLOCATABLE :: dfacei, &
&  dfacej, dfacek
  REAL(KIND=REALTYPE), DIMENSION(:, :, :, :, :), ALLOCATABLE :: dfaceid&
&  , dfacejd, dfacekd
  REAL(KIND=REALTYPE), DIMENSION(:, :, :, :), ALLOCATABLE :: s0
  REAL(KIND=REALTYPE), DIMENSION(:, :, :, :), ALLOCATABLE :: s0d
  REAL :: result1
  REAL :: result2
  INTRINSIC MAXVAL
!**************************
! Begin execution
!**************************
! SAVE DFACE VALUES TO BE PASSED TO WARPBLK
!          ALLOCATE(DFACEI(3,0:JMAX+1,0:KMAX+1,2,4),DFACEJ(3,0:IMAX+1,0:KMAX+1,2,4),&
!               DFACEK(3,0:IMAX+1,0:JMAX+1,2,4))
  !PRINT*, 'allocating dface'
  ALLOCATE(dfaceid(3, 1:jmax, 1:kmax, 2, 4))
  ALLOCATE(dfacei(3, 1:jmax, 1:kmax, 2, 4))
  ALLOCATE(dfacejd(3, 1:imax, 1:kmax, 2, 4))
  ALLOCATE(dfacej(3, 1:imax, 1:kmax, 2, 4))
  ALLOCATE(dfacekd(3, 1:imax, 1:jmax, 2, 4))
  ALLOCATE(dfacek(3, 1:imax, 1:jmax, 2, 4))
  dfaceid = 0.0
  dfacei = 0.0
  dfacejd = 0.0
  dfacej = 0.0
  dfacekd = 0.0
  dfacek = 0.0
  dfaceid(1, 1:jmax, 1:kmax, 1, 1) = xyznewd(1, 1, 1:jmax, 1:kmax)
  dfacei(1, 1:jmax, 1:kmax, 1, 1) = xyznew(1, 1, 1:jmax, 1:kmax) - xyz0(&
&    1, 1, 1:jmax, 1:kmax)
  dfaceid(2, 1:jmax, 1:kmax, 1, 1) = xyznewd(2, 1, 1:jmax, 1:kmax)
  dfacei(2, 1:jmax, 1:kmax, 1, 1) = xyznew(2, 1, 1:jmax, 1:kmax) - xyz0(&
&    2, 1, 1:jmax, 1:kmax)
  dfaceid(3, 1:jmax, 1:kmax, 1, 1) = xyznewd(3, 1, 1:jmax, 1:kmax)
  dfacei(3, 1:jmax, 1:kmax, 1, 1) = xyznew(3, 1, 1:jmax, 1:kmax) - xyz0(&
&    3, 1, 1:jmax, 1:kmax)
  dfaceid(1, 1:jmax, 1:kmax, 2, 1) = xyznewd(1, imax, 1:jmax, 1:kmax)
  dfacei(1, 1:jmax, 1:kmax, 2, 1) = xyznew(1, imax, 1:jmax, 1:kmax) - &
&    xyz0(1, imax, 1:jmax, 1:kmax)
  dfaceid(2, 1:jmax, 1:kmax, 2, 1) = xyznewd(2, imax, 1:jmax, 1:kmax)
  dfacei(2, 1:jmax, 1:kmax, 2, 1) = xyznew(2, imax, 1:jmax, 1:kmax) - &
&    xyz0(2, imax, 1:jmax, 1:kmax)
  dfaceid(3, 1:jmax, 1:kmax, 2, 1) = xyznewd(3, imax, 1:jmax, 1:kmax)
  dfacei(3, 1:jmax, 1:kmax, 2, 1) = xyznew(3, imax, 1:jmax, 1:kmax) - &
&    xyz0(3, imax, 1:jmax, 1:kmax)
  dfacejd(1, 1:imax, 1:kmax, 1, 1) = xyznewd(1, 1:imax, 1, 1:kmax)
  dfacej(1, 1:imax, 1:kmax, 1, 1) = xyznew(1, 1:imax, 1, 1:kmax) - xyz0(&
&    1, 1:imax, 1, 1:kmax)
  dfacejd(2, 1:imax, 1:kmax, 1, 1) = xyznewd(2, 1:imax, 1, 1:kmax)
  dfacej(2, 1:imax, 1:kmax, 1, 1) = xyznew(2, 1:imax, 1, 1:kmax) - xyz0(&
&    2, 1:imax, 1, 1:kmax)
  dfacejd(3, 1:imax, 1:kmax, 1, 1) = xyznewd(3, 1:imax, 1, 1:kmax)
  dfacej(3, 1:imax, 1:kmax, 1, 1) = xyznew(3, 1:imax, 1, 1:kmax) - xyz0(&
&    3, 1:imax, 1, 1:kmax)
  dfacejd(1, 1:imax, 1:kmax, 2, 1) = xyznewd(1, 1:imax, jmax, 1:kmax)
  dfacej(1, 1:imax, 1:kmax, 2, 1) = xyznew(1, 1:imax, jmax, 1:kmax) - &
&    xyz0(1, 1:imax, jmax, 1:kmax)
  dfacejd(2, 1:imax, 1:kmax, 2, 1) = xyznewd(2, 1:imax, jmax, 1:kmax)
  dfacej(2, 1:imax, 1:kmax, 2, 1) = xyznew(2, 1:imax, jmax, 1:kmax) - &
&    xyz0(2, 1:imax, jmax, 1:kmax)
  dfacejd(3, 1:imax, 1:kmax, 2, 1) = xyznewd(3, 1:imax, jmax, 1:kmax)
  dfacej(3, 1:imax, 1:kmax, 2, 1) = xyznew(3, 1:imax, jmax, 1:kmax) - &
&    xyz0(3, 1:imax, jmax, 1:kmax)
  dfacekd(1, 1:imax, 1:jmax, 1, 1) = xyznewd(1, 1:imax, 1:jmax, 1)
  dfacek(1, 1:imax, 1:jmax, 1, 1) = xyznew(1, 1:imax, 1:jmax, 1) - xyz0(&
&    1, 1:imax, 1:jmax, 1)
  dfacekd(2, 1:imax, 1:jmax, 1, 1) = xyznewd(2, 1:imax, 1:jmax, 1)
  dfacek(2, 1:imax, 1:jmax, 1, 1) = xyznew(2, 1:imax, 1:jmax, 1) - xyz0(&
&    2, 1:imax, 1:jmax, 1)
  dfacekd(3, 1:imax, 1:jmax, 1, 1) = xyznewd(3, 1:imax, 1:jmax, 1)
  dfacek(3, 1:imax, 1:jmax, 1, 1) = xyznew(3, 1:imax, 1:jmax, 1) - xyz0(&
&    3, 1:imax, 1:jmax, 1)
  dfacekd(1, 1:imax, 1:jmax, 2, 1) = xyznewd(1, 1:imax, 1:jmax, kmax)
  dfacek(1, 1:imax, 1:jmax, 2, 1) = xyznew(1, 1:imax, 1:jmax, kmax) - &
&    xyz0(1, 1:imax, 1:jmax, kmax)
  dfacekd(2, 1:imax, 1:jmax, 2, 1) = xyznewd(2, 1:imax, 1:jmax, kmax)
  dfacek(2, 1:imax, 1:jmax, 2, 1) = xyznew(2, 1:imax, 1:jmax, kmax) - &
&    xyz0(2, 1:imax, 1:jmax, kmax)
  dfacekd(3, 1:imax, 1:jmax, 2, 1) = xyznewd(3, 1:imax, 1:jmax, kmax)
  dfacek(3, 1:imax, 1:jmax, 2, 1) = xyznew(3, 1:imax, 1:jmax, kmax) - &
&    xyz0(3, 1:imax, 1:jmax, kmax)
  !PRINT*, 'allocating s0'
  ALLOCATE(s0d(3, 0:imax+1, 0:jmax+1, 0:kmax+1))
  ALLOCATE(s0(3, 0:imax+1, 0:jmax+1, 0:kmax+1))
  s0d = 0.0
  s0 = 0.0
! CALL WARPBLK FOR THE CURRENT BLOCK IF ANY OF THE FACES OR EDGES IN THAT 
! BLOCK ARE IMPLICITLY OR EXPLICITLY PERTURBED
!  PRINT*, 'if maxval', ifaceptb, 'edge', iedgeptb
  result1 = MAXVAL(ifaceptb(1:6))
  result2 = MAXVAL(iedgeptb(1:12))
  IF (result1 .GE. 1 .OR. result2 .GE. 1) THEN
 !   PRINT*, 'calling warpblk'
    CALL WARPBLK_D(ifaceptb(1:6), iedgeptb(1:12), -3, 0, 1, imax, jmax, &
&             kmax, xyz0, s0, dfacei, dfaceid, dfacej, dfacejd, dfacek, &
&             dfacekd, xyznew, xyznewd)
  END IF
!  PRINT*, 'deallocating'
  DEALLOCATE(s0)
  DEALLOCATE(dfacei)
  DEALLOCATE(dfacej)
  DEALLOCATE(dfacek)
  DEALLOCATE(s0d)
  DEALLOCATE(dfaceid)
  DEALLOCATE(dfacejd)
  DEALLOCATE(dfacekd)
END SUBROUTINE WARP_LOCAL_D
