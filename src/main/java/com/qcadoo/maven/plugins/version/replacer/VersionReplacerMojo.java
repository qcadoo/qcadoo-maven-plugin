package com.qcadoo.maven.plugins.version.replacer;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;

/**
 * 
 * @author mady
 * @goal version-replace
 * @phase validate
 */
public class VersionReplacerMojo extends AbstractMojo {

	/**
	 * 
	 * @parameter expression="${project}"
	 * @required
	 * @readonly
	 * 
	 */
	private MavenProject project;

	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {
		project.getProperties().setProperty("version.replacer",
				project.getParent().getVersion().replaceAll("-SNAPSHOT", ""));
	}

}
