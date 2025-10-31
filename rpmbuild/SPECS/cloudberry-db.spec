Name:           cloudberry-db
Version:        1.0
Release:        1%{?dist}
Summary:        Cloudberry DB (prebuilt)
License:        Proprietary
Source0:        cloudberry-db.tar.gz
BuildArch:      x86_64

# Keep it minimal: no debuginfo for prebuilt binaries
%global debug_package %{nil}

%description
Cloudberry Database packaged from precompiled binaries.

%prep
%setup -q -c -T
tar -xzf %{SOURCE0}

%build
# no-op

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/local/
cp -a * %{buildroot}/usr/local/

%files
/usr/local/

