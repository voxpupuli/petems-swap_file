# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'swap_file class' do
  context 'swap_file' do
    context 'swapfilesize => 100' do
      it 'works with no errors' do
        pp = <<-EOS
        swap_file::files { 'default':
          ensure       => present,
          swapfilesize => '100MB',
          resize_existing => true,
        }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      it 'contains the given swapfile with the correct size (102396/100MB)' do
        shell('/sbin/swapon -s | grep /mnt/swap.1', acceptable_exit_codes: [0])
        shell('/bin/cat /proc/swaps | grep 102396', acceptable_exit_codes: [0])
      end
    end

    context 'resize swap file' do
      it 'works with no errors' do
        pp = <<-EOS
        swap_file::files { 'default':
          ensure          => present,
          swapfilesize    => '200MB',
          resize_existing => true,
        }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      it 'contains the given swapfile with the resized size (204796kb/200MB)' do
        shell('/sbin/swapon -s | grep /mnt/swap.1', acceptable_exit_codes: [0])
        shell('/bin/cat /proc/swaps | grep 204796', acceptable_exit_codes: [0])
      end
    end
  end
end
