//
//  PodcastsService.swift
//  
//
//  Created by Thomas Rademaker on 5/8/23.
//

import Foundation
import Get

public struct PodcastsService {
    private let apiClient = APIClient(configuration: configuration)
    private let basePath = "/podcasts"
    
    /// This call returns everything we know about the feed from the PodcastIndex Feed ID
    ///
    /// - parameter id: (Required) The PodcastIndex Feed ID
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byFeedId id: Int, pretty: Bool = false) async throws -> PodcastResult {
        try await podcast(path: "byfeedid", q: ("id", "\(id)"), pretty: pretty)
    }
    
    /// This call returns everything we know about the feed from the feed URL
    ///
    /// - parameter id: (Required) PodcastIndex Feed URL
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byFeedUrl url: String, pretty: Bool = false) async throws -> PodcastResult {
        try await podcast(path: "byfeedurl", q: ("url", url), pretty: pretty)
    }
    
    /// This call returns everything we know about the feed from the feed's GUID.
    /// The GUID is a unique, global identifier for the podcast. See the namespace spec for
    /// [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    ///
    /// - parameter guid: (Required) The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast.
    /// See the namespace spec for
    /// [guid](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid) for details.
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byGuid guid: String, pretty: Bool = false) async throws -> PodcastResult {
        try await podcast(path: "byguid", q: ("guid", guid), pretty: pretty)
    }
    
    /// This call returns everything we know about the feed from the iTunes ID
    ///
    /// - parameter id: (Required) The iTunes Feed ID to search for
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `Podcast` object containing information about the feed.
    public func podcast(byItunesId id: Int, pretty: Bool = false) async throws -> PodcastResult {
        try await podcast(path: "byitunesid", q: ("id", "\(id)"), pretty: pretty)
    }
    
    /// This call returns all feeds that support the specified
    /// [podcast namespace tag](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md).
    ///
    /// When called without a start_at value, the top 500 feeds sorted by popularity are returned in descending order.
    ///
    /// When called with a start_at value, the feeds are returned sorted by the feedId starting with the specified value
    /// up to the max number of feeds to return. The nextStartAt specifies the value to pass to the next start_at.
    /// Repeat this sequence until no items are returned.
    ///
    ///- parameter podcast-value: (Required) Get feeds supporting the value tag.
    ///Parameter shall not have a value
    ///- parameter max: Maximum number of results to return.
    ///- parameter start_at: Feed ID to start at for request
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    ///- returns: a  `SearchResult` object which has an array of `Podcast`s
    public func podcastByTag(max: Int? = nil, startAt: String? = nil, pretty: Bool = false) async throws -> PodcastArrayResult {
        try await podcasts(path: "bytag", q: ("podcast-value", nil), max: max, pretty: pretty, startAt: startAt)
    }
    
    /// This call returns all feeds marked with the specified [medium](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#medium) tag value.
    ///- parameter medium: (Required) The medium value to search for.
    /// Full list of possible values documented in [medium](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#medium) tag spec.
    ///- parameter max: Maximum number of results to return.
    ///- parameter start_at: Feed ID to start at for request
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///Parameter shall not have a value
    ///- returns: a  `SearchResult` object which has an array of `Podcast`s
    public func podcast(byMedium medium: String, max: Int? = nil, pretty: Bool = false) async throws -> PodcastArrayResult {
        try await podcasts(path: "bymedium", q: ("medium", medium), max: max, pretty: pretty)
    }
    
    /// This call returns the podcasts/feeds that in the index that are trending.
    /// - parameter max: Maximum number of results to return.
    /// - parameter since: Return items since the specified time. The value can be a unix epoch timestamp or a negative integer that represents a number of seconds prior to right now.
    /// - parameter lang: Specifying a language code (like "en") will return only episodes having that specific language.
    /// You can specify multiple languages by separating them with commas.
    /// If you also want to return episodes that have no language given, use the token "unknown". (ex. en,es,ja,unknown).
    /// Values are not case sensitive.
    /// - parameter cat: Use this argument to specify that you ONLY want episodes with these categories in the results.
    /// Separate multiple categories with commas.
    /// You may specify either the Category ID and/or the Category Name.
    /// Values are not case sensitive.
    /// The cat and notcat filters can be used together to fine tune a very specific result set.
    /// Category numbers and names can be found in the [Podcast Namespace documentation](https://github.com/Podcastindex-org/podcast-namespace/blob/main/categories.json)
    /// - parameter notcat: Use this argument to specify categories of episodes to NOT show in the results.
    /// Separate multiple categories with commas.
    /// You may specify either the Category ID and/or the Category Name.
    /// Values are not case sensitive.
    /// The cat and notcat filters can be used together to fine tune a very specific result set.
    /// Category numbers and names can be found in the [Podcast Namespace documentation](https://github.com/Podcastindex-org/podcast-namespace/blob/main/categories.json)
    ///- parameter pretty: If present, makes the output “pretty” to help with debugging.
    ///- returns: a  `SearchResult` object which has an array of `Podcast`s
    public func trendingPodcasts(max: Int? = nil, since: Date? = nil, lang: String? = nil, cat: String? = nil, notcat: String? = nil, pretty: Bool = false) async throws -> PodcastArrayResult {
        var query: [(String, String?)]? = []
                
        if let max {
            query?.append(("max", "\(max)"))
        }
        
        if pretty {
            query?.append(("pretty", nil))
        }
        
        if let since {
            query?.append(("since", "\(since)"))
        }
        
        if let lang {
            query?.append(("lang", lang))
        }
        
        if let cat {
            query?.append(("cat", cat))
        }
        
        if let notcat {
            query?.append(("notcat", notcat))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/trending", query: query)).value
    }
    
    /// This call returns all feeds that have been marked dead (dead == 1)
    /// Dead feeds can also be accessed from object storage at [https://public.podcastindex.org/podcastindex_dead_feeds.csv](https://public.podcastindex.org/podcastindex_dead_feeds.csv)
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging.
    /// Parameter shall not have a value
    ///- returns: a  `SearchResult` object which has an array of `Podcast`s
    public func deadPodcasts(pretty: Bool = false) async throws -> PodcastArrayResult {
        var query: [(String, String?)]?
        
        if pretty {
            query = [("pretty", nil)]
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/dead", query: query)).value
    }
    
    /// Helper method to facilitate all podcast methods that return a `PodcastResult`
    /// - parameter path: the path to append to the base path
    /// - parameter q: (Required) query to search for
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `PodcastResult` object which is has an embedded `Podcast`.
    private func podcast(path: String, q: (String, String?), pretty: Bool) async throws -> PodcastResult {
        var query: [(String, String?)]? = [q]
        
        if pretty {
            query?.append(("pretty", nil))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/\(path)", query: query)).value
    }
    
    /// Helper method to facilitate all podcast methods that return a `PodcastArrayResult`
    /// - parameter path: the path to append to the base path
    /// - parameter q: (Required) query to search for
    /// - parameter pretty: If present, makes the output “pretty” to help with debugging. Parameter shall not have a value
    /// - returns: a `PodcastArrayResult` object which is has an embedded `Podcast` array.
    private func podcasts(path: String, q: (String, String?), max: Int? = nil, pretty: Bool, startAt: String? = nil) async throws -> PodcastArrayResult {
        var query: [(String, String?)]? = [q]
                
        if let max {
            query?.append(("max", "\(max)"))
        }
        
        if pretty {
            query?.append(("pretty", nil))
        }
        
        if let startAt {
            query?.append(("start_at", startAt))
        }
        
        return try await apiClient.send(Request(path: "\(basePath)/\(path)", query: query)).value
    }
}
