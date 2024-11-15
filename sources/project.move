module NFTCollectionTracker::NFTCollection {
    use aptos_framework::signer;
    use aptos_framework::account;
    use aptos_framework::event::{Self, EventHandle, events::CollectionCreated};

    struct NFTCollection has key, store {
        name: string::String,
        description: string::String,
        owner: address,
        total_nfts: u64,
        created_events: EventHandle<CollectionCreated>
    }

    public fun create_collection(creator: &signer, name: string::String, description: string::String) {
        let owner = signer::address_of(creator);
        let collection = NFTCollection {
            name,
            description,
            owner,
            total_nfts: 0,
            created_events: account::new_event_handle<CollectionCreated>(creator)
        };
        move_to(creator, collection);
        event::emit_event(&mut collection.created_events, CollectionCreated { name: name, owner });
    }

    public fun mint_nft(owner: &signer, collection: &mut NFTCollection) {
        let owner_address = signer::address_of(owner);
        assert!(owner_address == collection.owner, 0);
        collection.total_nfts = collection.total_nfts + 1;
    }
}