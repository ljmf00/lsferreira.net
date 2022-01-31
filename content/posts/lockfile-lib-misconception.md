---
title: 'The controversy and misconception around package managers lockfile in
libraries'
date: '2022-01-31T00:48:00+01:00'
tags: ['lockfiles', 'package-managers', 'packaging', 'dependencies',
'reproducible-builds', 'reproducible', 'deterministic']
description: "This post describes the common misconception and controversy
around package managers philosophy about the abomination of lockfiles in
packages, more specifically in libraries."
---

**NOTE:** I'm making this because I feel like this should be clarified. I had a
lot of discussions where people were biased by other opinions, mostly due to
spread misconceptions about these files. I can update this later with a more
fundamental reason if I see even more controversy on discussions I have in a
near future.

A lot of package managers use a lockfile mechanism to reliably reproduce their
packages across different environments. This mechanism is used when other
environments build packages that do not use pinned dependency versions and end
up using a modified version compatible with the version expression specified in
the package manifest file.

## But what is a lock file?

A lockfile is normally a generated file by the package manager that contains
the information about the exact versions currently used to build a package
successfully the way is intended to be. Some lockfiles include other metadata
about the package used such as checksums to ensure integrity.

### Advantages

One of the biggest advantages is to make deterministic dependency resolution.
This way, package managers can more easily replicate the same builds on
different environments. With that, you can also build your own package more
consistently. Both help users and developers seeking problems and can decrease
test suite failures on development.

### Security risk

It is straightforward to understand the advantages of a lockfile but some
people don't understand the _" disadvantages"_ and intentionally skip lockfiles
review, which is a tremendously bad idea; let me explain to you why.

For example, GitHub has a bad security issue related to detached references
that allow any user to create a fork of the repo and associate a commit to the
original repo. See the example of Linus Torvalds' `linux` mirror with
[this](https://github.com/torvalds/linux/tree/8bcab0346d4fcf21b97046eb44db8cf37ddd6da0)
commit. Because git obviously allows anyone to create commits with any email,
GitHub automatically associates it as the real Linus Torvalds. So a user can
easily create a security vulnerability, bump a patch version and change the
commit hash on the lockfile accordingly, making it a poisoned environment,
without being too obvious.

Another problem related to other external services can rise. The problem here
is trusting the source and the underlying service, falling into accepting
changes that can't be easily verified by just looking at it. Should we trust
any commit coming from `github.com/torvalds/linux`? Yes, but apparently not.

This can be mitigated using GPG signatures. Linux releases, for example, are
all signed by a group of trusted keys. That way we can trust that release tag
by verifying the underlying signature.

Therefore committing these files should be made and reviewed with caution and
in a trusted environment.

## You might say, why not pin the versions, instead?

Well, if [semantic versioning](https://semver.org/) standard is strictly
followed by the package maintainers, breaking changes wouldn't be a big of a
deal, although, the package will always be different. In a real-world
situation, breaking changes happen all the time, even if the intention is only
a bug fix. Sometimes things get out of control and because of today's systems
complexity, regression bugs can easily happen.

However, specifying a version range covering patches or minor versions is more
practically useful for a situation where the latest non-breakable version is
preferable.

Also, just pinning versions doesn't solve integrity issues and lockfiles does.

## Why reproducible builds are important?

Quoting Reproducible Builds project:

> The motivation behind the Reproducible Builds project is therefore to allow
> verification that no vulnerabilities or backdoors have been introduced during
> this compilation process. By promising identical results are always generated
> from a given source, this allows multiple third parties to come to a
> consensus on a “correct” result, highlighting any deviations as suspect and
> worthy of scrutiny.

You can read more about the project and their motivation along with tools to
make your builds more reproducible, [here](https://reproducible-builds.org/).

## The controversy and misconception part

Here is where the rant starts. A lot of package managers and maintainers have,
behind them, a strong philosophy about not including lockfiles for libraries.
This is something I can't really understand, given the rationale.

For example, the Rust package manager, Cargo, doesn't generate lockfiles by
default for libraries:

> This property is most desirable from applications and packages which are at
> the very end of the dependency chain (binaries). As a result, it is
> recommended that all binaries check in their Cargo.lock.
>
> For libraries the situation is somewhat different. A library is not only used
> by the library developers, but also any downstream consumers of the library.
> Users dependent on the library will not inspect the library’s Cargo.lock
> (even if it exists). This is precisely because a library should not be
> deterministically recompiled for all users of the library.

You can read more about this on "The Cargo Book",
[here](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

The last sentence is just wrong. Libraries should indeed be deterministically
recompiled to ensure consistency. That might not be true for the end-user, but
this is essential for the library developers to detect if an introduced change
caused problems. Essentially, packages should test their environment against
their supported version ranges and their locked reproducible environment.
Testing only one of those is wrong, and that is probably the root of the
misconception.

Many other package managers do claim the same thing and it seems they justify
themselves with each other claims. The worst part is the fact that some
maintainers decline including lockfiles in their projects and others create
pull requests/issues requesting to remove lockfiles, without thinking logically
about the problem and consequences, hence my frustration.

Fortunately, there is some clarification articles out there, including
[yarn](https://classic.yarnpkg.com/blog/2016/11/24/lockfiles-for-all/) blog
post and [Shalvah's blog
post](https://blog.shalvah.me/posts/understanding-lockfiles) that you should
check out, although there is a lot of bold claims that don't make sense.

From
[sindresorhus/ama/issues/479](https://github.com/sindresorhus/ama/issues/479#issuecomment-309440715):

> The lockfile defeats the whole purpose of the caret ^ that is the default
> save behavior. And it prevents us from getting security patches immediately,
> which is insane. There are more good updates than bad updates, so it does
> more harm than good. The idea that it protects us from malicious code is
> silly because there's no way in hell that people are actually auditing the
> entire dependency graph when they do finally get around to updating the
> lockfile. It's a fallacy that leads to a false sense of security.

Lockfiles are NOT there to prevent security issues, they are there to reproduce
environments. If you rely on lockfiles for security, you are doing it wrong.
Nothing prevents you from ignoring the lockfile as a user and you should patch
upstream if there is a security issue on some dependency. As a developer you
might want to proactively update that file, but also keep them to reproduce
your application/library.

From [dev.to, When not to use
package-lock.json](https://dev.to/gajus/stop-using-package-lock-json-or-yarn-lock-3ddi):

> The origin of this misuse is NPM documentation. It should instead explain
> that package-lock.json should only be committed to the source code version
> control when the project is not a dependency of other projects, i.e.
> package-lock.json should only by committed to source code version control for
> top-level projects (programs consumed by the end user, not other programs).
>
> [...]
>
> I would support a variation of package-lock.json if it could somehow only
> apply to devDependencies. I can see some (albeit small and with tradeoffs)
> benefit to wanting your development environment not break if there is a
> broken release among your dependencies.

Testing only with lockfiles is wrong, as well as living in the bleeding edge
world by testing only with the latest version. You should test both or ideally,
all the versions your manifest file supports. Only covering `devDependencies`
is also a claim that makes zero sense. Normal `dependencies` may not be part of
the build process but of the execution/runtime part of your
application/library, and should indeed be reproducible.

## Conclusion

The conclusion is simple, please consider using a lockfile. Don't assume that
semantic versioning is followed strictly because that is utopic. Also, make
your testsuite deterministic and wide to your dependency requirements. Someone
from the outside will touch your library, possibly try to contribute and
complain about their testsuite failing due to an unknown
[Heisenbug](https://ipfs.io/ipfs/bafkreigrsldz4g6eubx47ubp7qh7bqr4cd4copde35awdac3w6bwbt2lem),
most likely a side effect caused by a dependency, conducting an effort to
discover a problem, just because you are against lockfiles.
