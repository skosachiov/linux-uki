#
# UEFI boot testing
#
# Copyright (C) 2019 Canonical, Ltd.
# Author: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import subprocess
import sys
import unittest

from uefi_tests_base import UEFITestsBase, UEFINotAvailable, UEFIVirtualMachine


class UEFIBootTests(UEFITestsBase):
    """
    Validate UEFI signatures for common problems
    """
    @classmethod
    def setUpClass(klass):
        UEFITestsBase.setUpClass()
        klass.base_image = UEFIVirtualMachine(arch=klass.image_arch)
        #klass.base_image.prepare()

    def testCanary(self):
        """Validate that a control/canary (unchanged) image boots fine"""
        canary = UEFIVirtualMachine(self.base_image)
        canary.run()
        self.assertBoots(canary)

    def testNewLinuxUki(self):
        """Validate that a new LINUX_UKI binary on the image will boot"""
        new_linux-uki = UEFIVirtualMachine(self.base_image)
        new_linux-uki.update(src='/usr/lib/linux-uki/linux-ukix64.efi.signed', dst='/boot/efi/EFI/debian/linux-ukix64.efi')
        new_linux-uki.update(src='/usr/lib/linux-uki/linux-ukix64.efi.signed', dst='/boot/efi/EFI/BOOT/BOOTX64.efi')
        new_linux-uki.run()
        self.assertBoots(new_linux-uki)


unittest.main(testRunner=unittest.TextTestRunner(stream=sys.stdout, verbosity=2))
