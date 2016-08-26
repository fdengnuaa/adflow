       subroutine releaseHelpVariablesWriting
!
!       releaseHelpVariablesWriting releases the memory of the         
!       variables, which were needed to write the CGNS files.          
!
       use cgnsGrid
       use monitor
       use outputMod
       use utils, only : terminate
       implicit none
!
!      Local variables
!
       integer :: ierr

       ! Release the memory of the allocatable arrays in outputMod.

       deallocate(nBlocksCGNSblock, blocksCGNSblock, stat=ierr)
       if(ierr /= 0)                                   &
         call terminate("releaseHelpVariablesWriting", &
                        "Deallocation failure for nBlocksCGNSblock, &
                        &etc.")

       end subroutine releaseHelpVariablesWriting
