import Text "mo:base/Text";

import Time "mo:base/Time";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";

actor {
    // Post type definition
    public type Post = {
        id: Nat;
        title: Text;
        body: Text;
        author: Text;
        timestamp: Int;
    };

    // Stable variable to store posts
    stable var posts : [Post] = [];
    stable var nextId : Nat = 0;

    // Create a new post
    public shared func createPost(title: Text, body: Text, author: Text) : async Post {
        let post : Post = {
            id = nextId;
            title = title;
            body = body;
            author = author;
            timestamp = Time.now();
        };
        
        nextId += 1;
        
        // Create a new buffer with existing posts
        let postsBuffer = Buffer.fromArray<Post>(posts);
        postsBuffer.add(post);
        posts := Buffer.toArray(postsBuffer);
        
        return post;
    };

    // Get all posts sorted by timestamp (newest first)
    public query func getPosts() : async [Post] {
        Array.sort<Post>(posts, func(a, b) {
            if (a.timestamp > b.timestamp) { #less }
            else if (a.timestamp < b.timestamp) { #greater }
            else { #equal }
        })
    };
}
