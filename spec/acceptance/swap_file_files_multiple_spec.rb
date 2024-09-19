# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'swap_file::files defined type' do
  context 'multiple swap_file::files' do
    it 'works with no errors' do
      pp = <<-EOS
      swap_file::files { 'tmp file swap 1':
      ensure   => present,
        swapfile => '/tmp/swapfile1',
      }

      swap_file::files { 'tmp file swap 2':
      ensure   => present,
        swapfile => '/tmp/swapfile2',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'contains the given swapfile' do
      shell('/sbin/swapon -s | grep /tmp/swapfile1', acceptable_exit_codes: [0])
      shell('/sbin/swapon -s | grep /tmp/swapfile2', acceptable_exit_codes: [0])
    end

    it 'contains the default fstab setting' do
      shell('cat /etc/fstab | grep /tmp/swapfile1', acceptable_exit_codes: [0])
      shell('cat /etc/fstab | grep /tmp/swapfile2', acceptable_exit_codes: [0])
    end
  end
end
