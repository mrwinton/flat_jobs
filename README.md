<div align="center">

# __flat jobs__

</div>

FlatJobs is a project for curating a personalised job board by [git-scraping]
company-hosted careers pages into flat files. This is an alternative to the
_one-size-fits-all_ approach from job aggregator sites that do not spark joy.

Its design is guided by these values:

+ **Flat first.** Plain ol' text files over slow and heavy web apps. It's just
  flat data, view it how you like (tho GitHub's [Flat Viewer] is nice).
  
+ **Scrape for later.** Track scraped company career page's changes overtime
  using git and make it possible to view trends in jobs and job attributes.
  
+ **Automated.** There shouldn't be any recurring input or intervention
  necessary. Although, when things do go wrong, get notified.
  
+ **Easy to add.** Adding companies should be easy, without needing to
  internalise how the system works each time.
  
Checkout the current [flat jobs].

## Development

FlatJobs uses [nix] to setup dev environment easily. 

```shell
# First, install nix. See nix docs for more details.
$ curl -L https://nixos.org/nix/install | sh

# Then clone the repo.
$ git clone https://github.com/mrwinton/flat_jobs

# Change to the directory
$ cd flat_jobs

# Go into nix shell, the nix shell will auto setup the dev environment
$ nix-shell 

# Install gems
$ bundle

# Run flat jobs
$ bundle exec rake update
```

## Testing

```shell
# Runing specs, code coverage and linter
$ bundle exec rake test
```

## License

The project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[git-scraping]:https://simonwillison.net/2020/Oct/9/git-scraping/
[Flat Viewer]:https://github.com/githubocto/flat-viewer
[flat jobs]:https://flatgithub.com/mrwinton/flat_jobs?filename=data%2Fgold%2Fflat_jobs.csv
[nix]:(https://nixos.org)
