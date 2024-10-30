export type GithubRepoTreeItem = {
  path: string // '.obsidian/core-plugins.json';
  mode: string // '100644';
  type: string // 'blob';
  sha: string // '436f43cf561e4d8645a8612ddb5b0dee97f2fcc5';
  size: number // 637;
  url: string // 'https://api.github.com/repos/otmjka/log-content/git/blobs/436f43cf561e4d8645a8612ddb5b0dee97f2fcc5';
}

export type GitHubRepoTreeResponse = {
  sha: string
  url: string
  tree: GithubRepoTreeItem[]
}
