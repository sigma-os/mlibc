
libc_CXX := x86_64-managarm-g++

libc_CPPFLAGS := -std=c++1z -Wall
libc_CPPFLAGS += -I$(TREE_PATH)/options/internal/private
libc_CPPFLAGS += -I$(TREE_PATH)/options/ansi/include
libc_CPPFLAGS += -I$(TREE_PATH)/options/linux/include
libc_CPPFLAGS += -I$(TREE_PATH)/options/lsb/include
libc_CPPFLAGS += -I$(TREE_PATH)/options/posix/include
libc_CPPFLAGS += -I$(TREE_PATH)/options/internal/include
libc_CPPFLAGS += -I$(TREE_PATH)/sysdeps/managarm/include
libc_CPPFLAGS += -Igen
libc_CPPFLAGS += -I$(FRIGG_PATH)/include
libc_CPPFLAGS += -DFRIGG_HAVE_LIBC -DFRIGG_HIDDEN

libc_CXXFLAGS := $(libc_CPPFLAGS) -fPIC -O2
libc_CXXFLAGS += -fno-builtin -fno-rtti -fno-exceptions

libc_BEGIN := options/internal/gcc-extra/mlibc_crtbegin.o
libc_END := options/internal/gcc-extra/mlibc_crtend.o

libc_gendir := gen/

libc_include_dirs := options/internal/include \
	options/ansi/include \
	options/posix/include \
	options/lsb/include \
	options/linux/include

install_header_cmd = install -Dp $< $@

#Ansi
libc_includes := alloca.h \
	assert.h \
	ctype.h \
	errno.h \
	inttypes.h \
	limits.h \
	locale.h \
	math.h \
	bits/ansi/clockid_t.h \
	bits/ansi/ensure.h \
	bits/ansi/seek.h \
	bits/ansi/timespec.h \
	bits/ansi/time_t.h \
	setjmp.h \
	signal.h \
	stdio.h \
	stdlib.h \
	string.h \
	time.h \
	wchar.h
#Internal
libc_includes += bits/types.h \
	bits/machine.h \
	bits/null.h \
	bits/size_t.h \
	bits/wchar_t.h \
	stdint.h
#Linux
libc_includes += getopt.h \
	linux/bpf_common.h \
	linux/filter.h \
	linux/input.h \
	linux/magic.h \
	linux/netlink.h \
	linux/sched.h \
	linux/sockios.h \
	linux/types.h \
	malloc.h \
	mntent.h \
	poll.h \
	stdio_ext.h \
	sys/epoll.h \
	sys/inotify.h \
	sys/ioctl.h \
	sys/mount.h \
	sys/random.h \
	sys/sendfile.h \
	sys/sysmacros.h
#LSB
libc_includes += sys/auxv.h
#Posix
libc_includes += arpa/inet.h \
	byteswap.h \
	dirent.h \
	dlfcn.h \
	endian.h \
	fcntl.h \
	fnmatch.h \
	ftw.h \
	glob.h \
	grp.h \
	langinfo.h \
	libgen.h \
	bits/posix/blkcnt_t.h \
	bits/posix/blksize_t.h \
	bits/posix/dev_t.h \
	bits/posix/file.h \
	bits/posix/fsblkcnt_t.h \
	bits/posix/fsfilcnt_t.h \
	bits/posix/gid_t.h \
	bits/posix/id_t.h \
	bits/posix/in_addr_t.h \
	bits/posix/ino_t.h \
	bits/posix/in_port_t.h \
	bits/posix/iovec.h \
	bits/posix/locale_t.h \
	bits/posix/mode_t.h \
	bits/posix/nlink_t.h \
	bits/posix/nl_item.h \
	bits/posix/off_t.h \
	bits/posix/pid_t.h \
	bits/posix/posix_errno.h \
	bits/posix/posix_signal.h \
	bits/posix/posix_stdio.h \
	bits/posix/posix_stdlib.h \
	bits/posix/posix_string.h \
	bits/posix/sa_family_t.h \
	bits/posix/socklen_t.h \
	bits/posix/ssize_t.h \
	bits/posix/stat.h \
	bits/posix/suseconds_t.h \
	bits/posix/timeval.h \
	bits/posix/uid_t.h \
	net/if.h \
	netdb.h \
	netinet/in.h \
	netinet/ip.h \
	pthread.h \
	pwd.h \
	sched.h \
	spawn.h \
	strings.h \
	sys/file.h \
	sys/mman.h \
	sys/param.h \
	sys/resource.h \
	sys/select.h \
	sys/socket.h \
	sys/statfs.h \
	sys/stat.h \
	sys/statvfs.h \
	sys/time.h \
	sys/types.h \
	sys/uio.h \
	sys/un.h \
	sys/utsname.h \
	sys/vfs.h \
	sys/wait.h \
	syslog.h \
	termios.h \
	unistd.h

$(foreach d,$(libc_include_dirs),\
	$(eval $(SYSROOT_PATH)/usr/include/%.h: $d/%.h ; $(value install_header_cmd)))

$(SYSROOT_PATH)/usr/lib/libc.so: libc.so
	install -Dp $< $@

libc_code_dirs := options/ansi/generic
libc_code_dirs += options/linux/generic
libc_code_dirs += options/lsb/generic
libc_code_dirs += options/posix/generic
libc_code_dirs += options/internal/gcc \
	options/internal/gcc-extra \
	options/internal/x86_64
libc_code_dirs += sysdeps/managarm/generic

libc_s_sources := $(wildcard $(TREE_PATH)/options/internal/x86_64/*.S)

libc_cxx_sources := $(wildcard $(TREE_PATH)/options/ansi/generic/*.cpp)
libc_cxx_sources += $(wildcard $(TREE_PATH)/options/linux/generic/*.cpp)
libc_cxx_sources += $(wildcard $(TREE_PATH)/options/lsb/generic/*.cpp)
libc_cxx_sources += $(wildcard $(TREE_PATH)/options/posix/generic/*.cpp)
libc_cxx_sources += $(wildcard $(TREE_PATH)/options/internal/gcc/*.cpp)
libc_cxx_sources += $(wildcard $(TREE_PATH)/sysdeps/managarm/generic/*.cpp)

libc_objects := $(patsubst $(TREE_PATH)/%.cpp,%.o,$(libc_s_sources))
libc_objects += $(patsubst $(TREE_PATH)/%.cpp,%.o,$(libc_cxx_sources))

libc_AS := x86_64-managarm-as
libc_ASFLAGS := 

vpath %.h $(TREE_PATH)
vpath %.S $(TREE_PATH)
vpath %.cpp $(TREE_PATH)

$(libc_code_dirs):
	mkdir -p $@

$(libc_gendir):
	mkdir -p $@

%.o: %.S | $(libc_code_dirs)
	$(libc_AS) -o $@ $($libc_ASFLAGS) $<

%.o: %.cpp | $(libc_code_dirs)
	$(libc_CXX) -c -o $@ $(libc_CXXFLAGS) $<
	$(libc_CXX) $(libc_CPPFLAGS) -MM -MP -MF $(@:%.o=%.d) -MT "$@" -MT "$(@:%.o=%.d)" $<

libc.so: $(libc_objects) $(libc_BEGIN) $(libc_END)
	x86_64-managarm-g++ -shared -o $@ -nostdlib $(libc_BEGIN) $(libc_objects) -l:ld-init.so $(libc_END)

gen-libc: $(libc_gendir)/posix.frigg_pb.hpp $(libc_gendir)/fs.frigg_pb.hpp

install-headers-libc: $(addprefix $(SYSROOT_PATH)/usr/include/,$(libc_includes))

install-libc: $(addprefix $(SYSROOT_PATH)/usr/include/,$(libc_includes))
install-libc: $(SYSROOT_PATH)/usr/lib/libc.so

$(libc_gendir)/%.frigg_pb.hpp: $(MANAGARM_SRC_PATH)/bragi/proto/%.proto | $(libc_gendir)
	$(PROTOC) --plugin=protoc-gen-frigg=$(MANAGARM_BUILD_PATH)/tools/frigg_pb/bin/frigg_pb \
			--frigg_out=$(libc_gendir) --proto_path=$(MANAGARM_SRC_PATH)/bragi/proto $<
