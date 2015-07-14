# This file is NOT licensed under the GPLv3, which is the license for the rest
# of YouCompleteMe.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

import os

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
FLAGS = [
'-w',
#'-Wall',
#'-Wextra',
#'-Werror',
# '-Wc++98-compat',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',
# You 100% do NOT need -DUSE_CLANG_COMPLETER in your flags; only the YCM
# source code needs it.
#'-DUSE_CLANG_COMPLETER',
# THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
# language to use when compiling headers. So it will guess. Badly. So C++
# headers will be compiled as C headers. You don't want that so ALWAYS specify
# a "-std=<something>".
# For a C project, you would set this to something like 'c99' instead of
# 'c++11'.
# '-std=c99',
# ...and the same thing goes for the magic -x option which specifies the
# language that the files to be compiled are written in. This is mostly
# relevant for c++ headers.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c++',
'-I',
'bin/tests/mpm2_airspace/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_charts/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_gpu_resources/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_mdb_util/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_tdb_util/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_tfr/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_user_waypoints/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_wx_radar/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui',
'-I',
'bin/tests/mpm2_wx_util/vs-8.0/dbg/lnk-sttc/thrd-mlt/utf.m-gui'
]

# Root paths is the tuple of path names we are looking for intentionally have
# "dev" as the first one so we can us an index to see if we use src or not
ROOT_PATHS = ( 'dev', 'src' )

# These are the blacklisted directories, things you don't want to walk into
DIRECTORY_BLACKLIST = ( '.git', '.sbas', 'bin', 'expected', 'mswu', 'msvc' )

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
    return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
    if not working_directory:
        return list( flags )
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith( '/' ):
                new_flag = os.path.join( working_directory, flag )
                new_flag = new_flag.replace('\\','/')

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith( path_flag ):
                path = flag[ len( path_flag ): ]
                new_flag = path_flag + os.path.join( working_directory, path )
                break

        if new_flag:
            new_flags.append( new_flag )
    return new_flags

def get_sub_directories( root_dir ):
    '''
    This will bring back a list of subdirectories for the passed in root
    directory.  The list will also have the '-I' in between each directory
    so that it can be passed directly to ycm and clang.
    Any directories in the DIRECTORY_BLACKLIST will be skipped as well as
    any subdirectories in the blacklist.  If you want to add an explicit
    subdirectory of a blacklisted directory you'll need to add it to
    the FLAGS list.
    '''
    sub_dir_flags = []
    for root, dirs, files in os.walk(root_dir):
        #Skipp the blacklisted directories.
        for blacklisted in DIRECTORY_BLACKLIST:
            if blacklisted in dirs:
                dirs.remove(blacklisted)

        sub_dir_flags.append('-I')
        sub_dir_flags.append(root)


    return sub_dir_flags


def get_file_root_dir( filename ):
    '''
    The idea is walk up the file path until we find the root directory we
    care about.  To make this the most portable we are going to look for the
    "src" directory as long as the parent of the "src" directory isn't the
    "dev" directory.  This should work for projects like the G2xxx where
    everything is in the "src" directory.  It should also work for ACL
    development environments where things are in the "dev" directory.
    If neither directory is found this just returns None
    '''
    head, tail = os.path.split(filename)
    while tail and tail not in ROOT_PATHS:
        head, tail = os.path.split(head)

    #if the tail wasn't the main root, ie. "dev" then try splitting one more
    #time
    if tail and tail != ROOT_PATHS[0]:
        temp_head, temp_tail = os.path.split(head)

        #if the split shows the main root then save that off.
        if temp_tail and temp_tail == ROOT_PATHS[0]:
            tail = temp_tail
            head = temp_head

    # If we had a tail and a head then make the file root
    # Otherwise just empty it.
    if tail and head:
        head = os.path.join(head, tail)
    else:
        head = None

    return head


def IsHeaderFile( filename ):
    extension = os.path.splitext( filename )[ 1 ]
    return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def GetCompilationInfoForFile( filename ):
    # The compilation_commands.json file generated by CMake does not have entries
    # for header files. So we do our best by asking the db for flags for a
    # corresponding source file, if any. If one exists, the flags for that file
    # should be good enough.
    if IsHeaderFile( filename ):
        basename = os.path.splitext( filename )[ 0 ]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists( replacement_file ):
                compilation_info = database.GetCompilationInfoForFile(
                    replacement_file )
                if compilation_info.compiler_flags_:
                    return compilation_info
        return None
    return database.GetCompilationInfoForFile( filename )


def FlagsForFile( filename, **kwargs ):
    #NBS: I don't think we normally get here this is just for compilation
    #commands json database.
    if database:
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object
        compilation_info = GetCompilationInfoForFile( filename )
        if not compilation_info:
            return None

        final_flags = MakeRelativePathsInFlagsAbsolute(
            compilation_info.compiler_flags_,
            compilation_info.compiler_working_dir_ )

    else:
        #NBS: we should normally get here so make the flags relative to the
        #project root directory
        final_flags = _get_file_flags(filename)

    return {
        'flags': final_flags,
        'do_cache': True
    }


def RawFlags(filename):
    """
    The flags as you'd pass them directly to clang
    """
    temp_flags = _get_file_flags(filename)

    # Need to concatenate the "-I" and the "dir".  Probably could do this using list
    # comprehension but I'm at a loss for a pretty example.
    prepend_i = False
    flags = []
    for flag in temp_flags:
        if prepend_i:
            flags.append('-I' + flag)
            prepend_i = False
        elif flag == "-I":
            prepend_i = True
        else:
            flags.append(flag)

    return flags


def _get_file_flags(filename):
    project_root = get_file_root_dir(filename)
    final_flags = MakeRelativePathsInFlagsAbsolute(FLAGS, project_root)

    #Now add in all subdirectories under the project root
    final_flags.extend(get_sub_directories(project_root))

    # Condition the c or c++ flags based on the filetype
    extension = os.path.splitext( filename )[ 1 ]
    if extension in ('.c'):
        final_flags.append('-std=c99')
    else:
        final_flags.append('-std=c++11')
    return final_flags
