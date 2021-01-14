describe Fastlane::Actions::TestbmAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The testbm plugin is working!")

      Fastlane::Actions::TestbmAction.run(nil)
    end
  end
end
