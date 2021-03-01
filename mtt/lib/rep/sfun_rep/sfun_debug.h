
#ifndef HAVE_SFUN_DEBUG_H
#define HAVE_SFUN_DEBUG_H


#if defined DEBUG && defined __GNUC__

#include <stdio.h>
#define PRINT_ENTER fprintf (stderr, "debug> Entered '%s'\n", __FUNCTION__);
#define PRINT_LEAVE fprintf (stderr, "debug> Leaving '%s'\n", __FUNCTION__);

#elif defined DEBUG && ! defined __GNUC__

#include <stdio.h>
#define PRINT_ENTER fprintf (stderr, "debug> Entered a function\n");
#define PRINT_LEAVE fprintf (stderr, "debug> Leaving a function\n");

#elif ! defined DEBUG

#define PRINT_ENTER
#define PRINT_LEAVE

#else

#error "Momentary lapse of logic : unreachable statement reached"

#endif


#endif /* HAVE_SFUN_DEBUG_H */
