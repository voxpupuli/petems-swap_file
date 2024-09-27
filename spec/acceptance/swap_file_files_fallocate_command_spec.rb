# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'swap_file::files defined type' do
  context 'fallocate command', unless: ['FreeBSD'].include?(fact('os.family')) do
    it 'works with no errors' do
      pp = <<-EOS
      swap_file::files { 'default':
        ensure   => present,
        cmd      => 'fallocate',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'contains the default swapfile' do
      shell('/sbin/swapon -s | grep /mnt/swap.1', acceptable_exit_codes: [0])
    end

    it 'contains the default fstab setting' do
      shell('cat /etc/fstab | grep /mnt/swap.1', acceptable_exit_codes: [0])
      shell('cat /etc/fstab | grep defaults', acceptable_exit_codes: [0])
    end
  end
end
