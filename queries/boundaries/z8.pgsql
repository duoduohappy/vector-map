SELECT
  st_linemerge(st_collect(way)) AS __geometry__,
  admin_level,
  (
    CASE
      WHEN admin_level = '2'
        THEN 'country'
      WHEN admin_level = '4'
        THEN 'region'
    END
  ) AS kind
FROM
  planet_osm_line
WHERE
  way && !bbox! AND
  boundary = 'administrative' AND admin_level IN ('2', '4')
GROUP BY admin_level, kind