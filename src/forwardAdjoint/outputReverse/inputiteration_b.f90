   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
   !
   !      ==================================================================
   MODULE INPUTITERATION_B
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Input parameters which are related to the iteration process,   *
   !      * i.e. multigrid parameters, cfl numbers, smoothers and          *
   !      * convergence.                                                   *
   !      *                                                                *
   !      ******************************************************************
   !
   USE PRECISION
   IMPLICIT NONE
   SAVE 
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of some parameters which make the code more         *
   !      * readable. The actual values of this parameters are arbitrary;  *
   !      * in the code always the symbolic names are (should be) used.    *
   !      *                                                                *
   !      ******************************************************************
   !
   INTEGER(kind=inttype), PARAMETER :: rungekutta=1, dadi=2, nllusgs=3, &
   & nllusgsline=4
   INTEGER(kind=inttype), PARAMETER :: segregated=1, coupled=2
   INTEGER(kind=inttype), PARAMETER :: gmres=1, adi=2
   INTEGER(kind=inttype), PARAMETER :: bcdirichlet0=0, bcneumann=1
   INTEGER(kind=inttype), PARAMETER :: noresaveraging=0, &
   & alwaysresaveraging=1, alternateresaveraging=2
   INTEGER(kind=inttype), PARAMETER :: turbrelaxnotdefined=0, &
   & turbrelaxexplicit=1, turbrelaximplicit=2
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the iteration input parameters.                  *
   !      *                                                                *
   !      ******************************************************************
   !
   ! nCycles:          Maximum number of multigrid cycles.
   ! nCyclesCoarse:    Idem, but on the coarse grids in full multigrid.
   ! nSaveVolume:      Number of fine grid cycles after which a volume
   !                   solution file is written.
   ! nSaveSurface:     Number of fine grid cycles after which a
   !                   surface solution file is written.
   ! nsgStartup:       Number of single grid iterations, before
   !                   switching to multigrid. Could be useful for
   !                   supersonic problems with strong shocks.
   ! nSubIterTurb:     Number of turbulent subiterations when using
   !                   a segregated approach for the turbulence.
   ! nUpdateBleeds:    Number of iterations after which the bleed
   !                   boundary conditions must be updated.
   ! smoother:         Smoother to be used.
   ! nRKStages:        Number of stages in the runge kutta scheme.
   ! nSubiterations:   Maximum number of subiterations used in
   !                   DADI.
   ! turbTreatment:    Treatment of the turbulent transport equations;
   !                   either segregated or coupled.
   ! turbSmoother:     Smoother to use in case a segregated solver
   !                   is to be used.
   ! turbRelax:        What kind of turbulent relaxation to use.
   !                   Either turbRelaxExplicit or
   !                   turbRelaxImplicit.
   ! resAveraging:     What kind of residual averaging to use.
   ! freezeTurbSource: Whether or not the turbulent source terms must
   !                   be frozen on the coarser grid levels; only if
   !                   a coupled solver is to be used.
   ! mgBoundCorr:      Treatment of the boundary halo's for the
   !                   multigrid corrections. Either dirichlet0,
   !                   set the corrections to zero, or neumann.
   ! mgStartlevel:     Grid level on which the multigrid must be
   !                   started in the full mg cycle. In case a restart
   !                   is specified this info is overruled and the
   !                   start level is the finest grid.
   ! nMGSteps:         Number of steps in the array cycleStrategy.
   ! nMGLevels:        Number of levels in the multigrid. This info
   !                   is derived from the cycle strategy.
   ! cycleStrategy:    Array which describes the mg cycle.
   ! cfl:              Cfl number on the fine grid.
   ! cflCoarse:        Idem, but on the coarse grids.
   ! cfllimit          Limit used to determine how much residuals are smoothed
   ! alfaTurb:         Relaxation factor in turbulent dd-adi smoother.
   ! betaTurb:         Relaxation factor in vf dd-adi smoother.
   ! relaxBleeds:      Relaxation coefficient for the update
   !                   of the bleed boundary condition.
   ! smoop:            Coefficient in the implicit smoothing.
   ! fcoll:            Relaxation factor for the restricted residuals.
   ! L2Conv:           Relative L2 norm of the density residuals for
   !                   which the computation is assumed converged.
   ! L2ConvCoarse:     Idem, but on the coarse grids during full mg.
   ! etaRk:            Coefficients in the runge kutta scheme. The
   !                   values depend on the number of stages specified.
   ! cdisRk:           Dissipative coefficients in the runge kutta
   !                   scheme. The values depend on the number of
   !                   stages specified.
   ! printIterations: If True, iterations are printed to stdout
   INTEGER(kind=inttype) :: ncycles, ncyclescoarse
   INTEGER(kind=inttype) :: nsavevolume, nsavesurface
   INTEGER(kind=inttype) :: nsgstartup, smoother, nrkstages
   INTEGER(kind=inttype) :: nsubiterations
   INTEGER(kind=inttype) :: nsubiterturb, nupdatebleeds
   INTEGER(kind=inttype) :: resaveraging
   REAL(kind=realtype) :: cfllimit
   INTEGER(kind=inttype) :: turbtreatment, turbsmoother, turbrelax
   INTEGER(kind=inttype) :: mgboundcorr, mgstartlevel
   INTEGER(kind=inttype) :: nmgsteps, nmglevels
   INTEGER(kind=inttype), DIMENSION(:), ALLOCATABLE :: cyclestrategy
   INTEGER(kind=inttype) :: miniternum
   REAL(kind=realtype) :: cfl, cflcoarse, fcoll, smoop
   REAL(kind=realtype) :: alfaturb, betaturb
   REAL(kind=realtype) :: l2conv, l2convcoarse
   REAL(kind=realtype) :: l2convrel
   REAL(kind=realtype) :: maxl2deviationfactor
   REAL(kind=realtype) :: relaxbleeds
   REAL(kind=realtype) :: epscoefconv
   INTEGER(kind=inttype) :: convcheckwindowsize
   REAL(kind=realtype), DIMENSION(:), ALLOCATABLE :: etark, cdisrk
   LOGICAL :: freezeturbsource
   LOGICAL :: printiterations
   LOGICAL :: printwarnings
   END MODULE INPUTITERATION_B
