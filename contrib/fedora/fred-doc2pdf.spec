%global __os_install_post %(echo '%{__os_install_post}' | sed -e 's!/usr/lib[^[:space:]]*/brp-python-bytecompile[[:space:]].*$!!g')
%define debug_package %{nil}

Summary: PDF creator module
Name: fred-doc2pdf
Version: %{our_version}
Release: %{?our_release}%{!?our_release:1}%{?dist}
Source0: %{name}-%{version}.tar.gz
License: GPLv3+
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: CZ.NIC <fred@nic.cz>
Url: https://fred.nic.cz/
BuildRequires: python2-setuptools
Requires: python-trml2pdf >= 1.2 gnu-free-sans-fonts python2-reportlab <= 3.4.0

%description
The module of the FRED system used for PDF generation

%prep
%setup -n %{name}-%{version}

%install
python2 setup.py install -cO2 --force --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES --prefix=/usr

mkdir -p $RPM_BUILD_ROOT/%{_sysconfdir}/fred/
install contrib/fedora/fred-doc2pdf.conf $RPM_BUILD_ROOT/%{_sysconfdir}/fred/

%clean
rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)
%config %{_sysconfdir}/fred/fred-doc2pdf.conf
