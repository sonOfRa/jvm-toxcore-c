resolvers += Classpaths.sbtPluginReleases

// Code style.
addSbtPlugin("org.scalastyle" %% "scalastyle-sbt-plugin" % "0.6.0")
addSbtPlugin("com.etsy" % "sbt-checkstyle-plugin" % "0.4.3")
addSbtPlugin("com.sksamuel.scapegoat" %% "sbt-scapegoat" % "0.94.6")
addSbtPlugin("org.brianmckenna" % "sbt-wartremover" % "0.13")

// Code formatting.
addSbtPlugin("com.typesafe.sbt" % "sbt-scalariform" % "1.3.0")

// Test coverage.
addSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.0.1")
addSbtPlugin("org.scoverage" % "sbt-coveralls" % "1.0.0.BETA1")

// Scala compiler options for SBT code.
scalacOptions ++= Seq("-feature", "-deprecation")

// Dependencies for SBT code.
libraryDependencies += "commons-io" % "commons-io" % "2.4"
