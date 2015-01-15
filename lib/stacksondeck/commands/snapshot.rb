module StacksOnDeck
  module Commands

    def snapshot_instance i
      log.info event: 'snapshot', instance: i
    end

  end
end