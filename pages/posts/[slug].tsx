import React from 'react'
import matter from 'gray-matter'
import { MDXRemote } from 'next-mdx-remote'
import { serialize } from 'next-mdx-remote/serialize'
import dynamic from 'next/dynamic'
import Head from 'next/head'
import Link from 'next/link'
import CustomLink from '../../components/CustomLink'
import Layout from '../../components/Layout'
import { getArticles } from '../../services/getArticles'
import { getGithubRawcontent } from '../../services/getGithubRawcontent'
// Custom components/renderers to pass to MDX.
// Since the MDX files aren't loaded by webpack, they have no knowledge of how
// to handle import statements. Instead, you must include components in scope
// here.
const components = {
  a: CustomLink,
  // It also works with dynamically-imported components, which is especially
  // useful for conditionally loading components for certain routes.
  // See the notes in README.md for more details.
  TestComponent: dynamic(() => import('../../components/TestComponent')),
  Head,
}
//
export default function PostPage({ source, frontMatter }) {
  return (
    <Layout>
      <header>
        <nav>
          <Link href="/" legacyBehavior>
            <a>👈 Go back home</a>
          </Link>
        </nav>
      </header>
      {/* <div className="post-header">
        <h1>{frontMatter.title}</h1>
        {frontMatter.description && (
          <p className="description">{frontMatter.description}</p>
        )}
      </div> */}
      <main>
        <MDXRemote {...source} components={components} />{' '}
      </main>

      <style jsx>{`
        .post-header h1 {
          margin-bottom: 0;
        }

        .post-header {
          margin-bottom: 2rem;
        }
        .description {
          opacity: 0.6;
        }
      `}</style>
    </Layout>
  )
}

export const getStaticProps = async ({ params }) => {
  const fileContent = await getGithubRawcontent({ fileName: params.slug })
  const { content, data } = matter(fileContent)
  const mdxSource = await serialize(content, {
    // Optionally pass remark/rehype plugins
    mdxOptions: {
      remarkPlugins: [],
      rehypePlugins: [],
    },
    scope: data,
  })
  return {
    props: {
      source: mdxSource,
      frontMatter: data,
    },
  }
}

export const getStaticPaths = async () => {
  const posts1 = await getArticles()
  const paths = posts1.articles
    .map((post) => post.path)
    .map((post) => ({ params: { slug: post } }))

  return {
    paths,
    fallback: false,
  }
}
