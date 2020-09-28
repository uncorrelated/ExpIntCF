program main
    implicit none
    integer::length = 100, i, j
    real :: t1, t2
    complex(kind(0d0)), allocatable, dimension(:, :) :: m

    call cpu_time( t1 )

    call MakeMatrix(0.1d0, 5.0d0, length, m)

    call cpu_time( t2 )
    print '("cpu time: ",f8.6," seconds.")', t2-t1

    open(1, file="e1_cf.f90.txt")

    do j=1, length
        do i=1, length
            write(1, '(f9.7,"+",f9.7,"im ")', advance='no') real(m(i,j)), aimag(m(i,j))
        end do 
        write(1,*) ""
    end do         

    close(1)

    deallocate(m)

    contains

    subroutine MakeMatrix(s, e, length, m)
        implicit none
        double precision s, e, x, y
        integer length, i, j
        complex(kind(0d0)), allocatable, dimension(:, :) :: m

        allocate( m(length, length) )
        do j=1, length
            x = s + (e - s)/(length - 1)*(j - 1)
            do i=1, length
                y = s + (e - s)/(length - 1)*(i - 1)
                m(i, j) = E1_cf(cmplx(x, y, kind(0d0)), 1d-12)
            end do
        end do

    end subroutine

    function E1_cf(z, reltol)
        implicit none
        integer n
        double precision reltol
        complex(kind(0d0)) z, E1_cf, s, d
        do n=1, 1000
            s = nE1_cf(z, n);
            d = nE1_cf(z, 2*n);
            if(cdabs(s - d) .lt. reltol*cdabs(d)) then
                E1_cf = d
                return
            end if
        end do
        write (0,*) "iteration limit exceeded!"
        call exit(-1)
        E1_cf = 0
    end function

    function nE1_cf(z, n)
        implicit none
        integer i, n
        complex(kind(0d0)) z, nE1_cf, cf

        cf = z
        do i=n, 1, -1
            cf = z + (1 + i) / cf
            cf = 1 + i / cf
        end do
        nE1_cf = cdexp(-1*z) / (z + 1/cf);
    end function
end program main
