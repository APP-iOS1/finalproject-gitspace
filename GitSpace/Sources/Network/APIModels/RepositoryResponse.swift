//
//  StarsResponse.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/09.
//


import Foundation

// FIXME: - QuickType 돌린 임시 모델, 필요한 데이터만 골라서 모델링 다시 하기  
struct RepositoryResponse: Codable {
    let id: Int
    let nodeID, name, fullName: String
    let owner: Owner
    let welcomePrivate: Bool
    let htmlURL: String
    let description: String?
    let fork: Bool
    let url: String
    let archiveURL, assigneesURL, blobsURL, branchesURL: String
    let collaboratorsURL, commentsURL, commitsURL, compareURL: String
    let contentsURL: String
    let contributorsURL, deploymentsURL, downloadsURL, eventsURL: String
    let forksURL: String
    let gitCommitsURL, gitRefsURL, gitTagsURL, gitURL: String
    let issueCommentURL, issueEventsURL, issuesURL, keysURL: String
    let labelsURL: String
    let languagesURL, mergesURL: String
    let milestonesURL, notificationsURL, pullsURL, releasesURL: String
    let sshURL: String
    let stargazersURL: String
    let statusesURL: String
    let subscribersURL, subscriptionURL, tagsURL, teamsURL: String
    let treesURL: String
    let cloneURL: String
    let mirrorURL: String
    let hooksURL, svnURL, homepage: String
    let language: String?
    let forksCount, stargazersCount, watchersCount, size: Int
    let defaultBranch: String
    let openIssuesCount: Int
    let isTemplate: Bool
    let topics: [String]
    let hasIssues, hasProjects, hasWiki, hasPages: Bool
    let hasDownloads, archived, disabled: Bool
    let visibility: String
    let pushedAt, createdAt, updatedAt: Date
    let permissions: Permissions
    let allowRebaseMerge: Bool
    let templateRepository: String?
    let tempCloneToken: String
    let allowSquashMerge, allowAutoMerge, deleteBranchOnMerge, allowMergeCommit: Bool
    let subscribersCount, networkCount: Int
    let license: License
    let forks, openIssues, watchers: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case welcomePrivate = "private"
        case htmlURL = "html_url"
        case description, fork, url
        case archiveURL = "archive_url"
        case assigneesURL = "assignees_url"
        case blobsURL = "blobs_url"
        case branchesURL = "branches_url"
        case collaboratorsURL = "collaborators_url"
        case commentsURL = "comments_url"
        case commitsURL = "commits_url"
        case compareURL = "compare_url"
        case contentsURL = "contents_url"
        case contributorsURL = "contributors_url"
        case deploymentsURL = "deployments_url"
        case downloadsURL = "downloads_url"
        case eventsURL = "events_url"
        case forksURL = "forks_url"
        case gitCommitsURL = "git_commits_url"
        case gitRefsURL = "git_refs_url"
        case gitTagsURL = "git_tags_url"
        case gitURL = "git_url"
        case issueCommentURL = "issue_comment_url"
        case issueEventsURL = "issue_events_url"
        case issuesURL = "issues_url"
        case keysURL = "keys_url"
        case labelsURL = "labels_url"
        case languagesURL = "languages_url"
        case mergesURL = "merges_url"
        case milestonesURL = "milestones_url"
        case notificationsURL = "notifications_url"
        case pullsURL = "pulls_url"
        case releasesURL = "releases_url"
        case sshURL = "ssh_url"
        case stargazersURL = "stargazers_url"
        case statusesURL = "statuses_url"
        case subscribersURL = "subscribers_url"
        case subscriptionURL = "subscription_url"
        case tagsURL = "tags_url"
        case teamsURL = "teams_url"
        case treesURL = "trees_url"
        case cloneURL = "clone_url"
        case mirrorURL = "mirror_url"
        case hooksURL = "hooks_url"
        case svnURL = "svn_url"
        case homepage, language
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case size
        case defaultBranch = "default_branch"
        case openIssuesCount = "open_issues_count"
        case isTemplate = "is_template"
        case topics
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case hasDownloads = "has_downloads"
        case archived, disabled, visibility
        case pushedAt = "pushed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case permissions
        case allowRebaseMerge = "allow_rebase_merge"
        case templateRepository = "template_repository"
        case tempCloneToken = "temp_clone_token"
        case allowSquashMerge = "allow_squash_merge"
        case allowAutoMerge = "allow_auto_merge"
        case deleteBranchOnMerge = "delete_branch_on_merge"
        case allowMergeCommit = "allow_merge_commit"
        case subscribersCount = "subscribers_count"
        case networkCount = "network_count"
        case license, forks
        case openIssues = "open_issues"
        case watchers
    }
}

struct Organization: Codable {
    let name, email: String?
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String?
    let url: String
    let htmlURL: String
    let followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsRUL: String
    let organizationsURL: String
    let reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    
    
    
}



// MARK: - License
struct License: Codable {
    let key, name: String
    let url: String?
    let spdxID: String?
    let nodeID: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case key, name, url
        case spdxID = "spdx_id"
        case nodeID = "node_id"
        case htmlURL = "html_url"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

// MARK: - Permissions
struct Permissions: Codable {
    let admin, push, pull: Bool
}

