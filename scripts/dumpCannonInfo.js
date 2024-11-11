const hre = require("hardhat");
const fs = require("fs");

async function getArtifactInfo(name) {
	const art = await hre.artifacts.readArtifact(name);
	if (art) {
		const dependencyGraph = await hre.run("compile:solidity:get-dependency-graph", {
			sourceNames: [art.sourceName],
		});

		const resolvedFile = dependencyGraph.getResolvedFiles()[0];

		const compileJob = await hre.run("compile:solidity:get-compilation-job-for-file", {
			file: resolvedFile,
			dependencyGraph,
		});

		const solidityInput = await hre.run("compile:solidity:get-compiler-input", {
			compilationJob: compileJob,
		});

		const buildInfo = await hre.artifacts.getBuildInfo(`${art.sourceName}:${art.contractName}`);
		art.source = {
			solcVersion: buildInfo.solcLongVersion,
			input: JSON.stringify(solidityInput),
		};
	}

	return art;
}

const artifacts = [
	"Diamond",
	"DiamondCutFacet",
	"DiamondLoupeFacet",
	"DiamondWipeAndPaveFacet",
	"OwnershipFacet",
];

(async function () {
	fs.mkdirSync("cannonArtifactData");
	for (const art of artifacts) {
		fs.writeFileSync(`cannonArtifactData/${art}.json`, JSON.stringify(await getArtifactInfo(art)));
	}
})();
