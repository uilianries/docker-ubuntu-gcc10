//
// Copyright(c) 2015 Gabi Melman.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

// spdlog usage example

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <zlib.h>

#ifdef WITH_UNWIND
#    include <libunwind.h>
#endif

int main(void) {
    char buffer_in [32] = {"Conan Package Manager"};
    char buffer_out [32] = {0};

#ifdef WITH_UNWIND
    unw_context_t uc;
    unw_cursor_t cursor;
    unw_getcontext (&uc);
    unw_init_local (&cursor, &uc);
#endif

    z_stream defstream;
    defstream.zalloc = Z_NULL;
    defstream.zfree = Z_NULL;
    defstream.opaque = Z_NULL;
    defstream.avail_in = (uInt) strlen(buffer_in);
    defstream.next_in = (Bytef *) buffer_in;
    defstream.avail_out = (uInt) sizeof(buffer_out);
    defstream.next_out = (Bytef *) buffer_out;


    deflateInit(&defstream, Z_BEST_COMPRESSION);
    deflate(&defstream, Z_FINISH);
    deflateEnd(&defstream);

    printf("Compressed size is: %lu\n", strlen(buffer_in));
    printf("Compressed string is: %s\n", buffer_in);
    printf("Compressed size is: %lu\n", strlen(buffer_out));
    printf("Compressed string is: %s\n", buffer_out);

    printf("ZLIB VERSION: %s\n", zlibVersion());

    return 0;
}
