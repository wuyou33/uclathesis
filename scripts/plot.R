library(ggplot2)
library(reshape)
library(grid)


setwd("/Users/akee/School/UCLA/01\ thesis/uclathesis")

full_width <- 5.5


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
#                      4 PRBS input sequences                         #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

data <- read.csv("data/prbs_input_sequence.csv", header = FALSE)

u1 <- data$V1
u2 <- data$V2
u3 <- data$V3
u4 <- data$V4
n <- seq_along(u1)

# recombine the individual measurements into a dataframe
df <- data.frame(n,u1,u2,u3,u4)

# melt that shit
df.melted <- melt(df, id = "n")

# plot
p <-
	ggplot(df.melted) +
	geom_step(aes(x = n, y = value)) +
	facet_grid(variable ~ .) +
	ylab("Input") +
	scale_y_continuous(breaks = seq(0,1,1)) +	# min, max, interval
	scale_x_continuous(breaks = seq(0,100,25))+	# min, max, interval

	theme(
		panel.margin = unit(0.2, "in"),
		panel.grid.minor = element_blank(),
		strip.text.y = element_text(angle = 0),
		axis.title.y = element_text(angle = 0, hjust = -0.25),
		axis.title.x = element_text(vjust = -0.25)
	)

pdf("fig/prbs_input.pdf", width = full_width, height=3.5)
print(p)
dev.off()



