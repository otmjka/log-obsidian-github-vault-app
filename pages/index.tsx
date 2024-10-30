import React from 'react'
import Link from 'next/link'
import Layout from '../components/Layout'
import { getArticles } from '../services/getArticles'

export default function Index({ posts }) {
  return (
    <Layout>
      <h1>log</h1>

      <ul>
        {posts.articles.map((post) => (
          <li key={post.path}>
            <Link as={`/posts/${post.path}`} href={`/posts/[slug]`}>
              {post.path}
            </Link>
          </li>
        ))}
      </ul>
    </Layout>
  )
}

export async function getStaticProps() {
  const posts = await getArticles()

  return { props: { posts } }
}
