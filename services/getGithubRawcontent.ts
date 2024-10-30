export const getGithubRawcontent = async ({
  fileName,
  repoName = 'otmjka/log-content',
}: {
  fileName: string
  repoName?: string
}) => {
  //api.github.com/repos/otmjka/log-content/git/blobs/4eb2b948a0f663a3abe7cf613011907bbadb13a6
  //

  const url = `https://raw.githubusercontent.com/${repoName}/refs/heads/main/${fileName}`
  const response = await fetch(url)
  const data = await response.text()
  console.log('###', data)
  return data
}
