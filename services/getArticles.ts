import { GitHubRepoTreeResponse } from '../types/types'

export const getArticles = async () => {
  const url =
    'https://api.github.com/repos/otmjka/log-content/git/trees/main?recursive=1'
  const response = await fetch(url)
  const data = (await response.json()) as GitHubRepoTreeResponse

  const mdFiles = data.tree.filter((item) => /\.md$/.test(item.path))

  const mdFileNames = mdFiles.map(({ path, url }) => ({
    path,
    url,
  }))
  return { articles: mdFileNames }
}
