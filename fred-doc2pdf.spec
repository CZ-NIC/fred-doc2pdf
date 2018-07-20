%define name fred-doc2pdf
%define release 1
%global __os_install_post %(echo '%{__os_install_post}' | sed -e 's!/usr/lib[^[:space:]]*/brp-python-bytecompile[[:space:]].*$!!g')
%define debug_package %{nil}

Summary: PDF creator module
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{unmangled_version}.tar.gz
License: GNU GPL
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: CZ.NIC <fred@nic.cz>
Url: https://fred.nic.cz
BuildRequires: fred-distutils
Requires: python-trml2pdf >= 1.2 /usr/share/fonts/dejavu/DejaVuSans.ttf

%description
The module of the FRED system

%prep
%setup -n %{name}-%{unmangled_version}

%build
python setup.py build


%install
python setup.py install -cO2 --force --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES --no-check-deps --prefix=/usr --install-sysconf=/etc --font-path=/usr/share/fonts/dejavu/ --font-names="DejaVuSans.ttf DejaVuSans-Oblique.ttf DejaVuSans-Bold.ttf DejaVuSans-BoldOblique.ttf"


%clean
rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)
