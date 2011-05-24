package com.qcadoo.maven.plugins.version.replacer;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
		
		String version = project.getVersion();
		String trimmedVersion = "";
		
		Pattern pattern = Pattern.compile("[0-9]+\\.[0-9]+\\.[0-9]+");
		Matcher matcher = pattern.matcher(version);
		if(matcher.find()) {
			trimmedVersion = matcher.group();
		}
		
		project.getProperties().setProperty("version.replacer",
				trimmedVersion);
	}

}
